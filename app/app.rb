##########################################################
##########################################################
##    _____         ___            _ _____       _      ##
##   |  ___|       / _ \          | |  _  |     | |     ##
##   | |_ _____  _/ /_\ \_ __   __| | | | | __ _| | __  ##
##   |  _/ _ \ \/ /  _  | '_ \ / _` | | | |/ _` | |/ /  ##
##   | || (_) >  <| | | | | | | (_| \ \_/ / (_| |   <   ##
##   \_| \___/_/\_\_| |_/_| |_|\__,_|\___/ \__,_|_|\_\  ##
##                                                      ##
##########################################################
##########################################################
##              Main Sinatra app.rb file                ##
## Allows us to define, manage and serve various routes ##
##########################################################
##########################################################

# => Constants
# => This calls the constants for the application
# => Used to have all the constants defined here, but need them in a separate dir
require_relative '../config/constants'

##########################################################
##########################################################

# => Load
# => This replaces individual requires with bundled gems
# => https://stackoverflow.com/a/1712669/1143732
require 'bundler/setup'

# => Pulls in all Gems
# => Replaces the need for individual gems
Bundler.require :default, ENVIRONMENT if defined?(Bundler) # => ENVIRONMENT only used here, can do away with constant if necessary

##########################################################
##########################################################

# => Models
# => This allows us to load all the models (which are not loaded by default)
require_all 'app', 'lib'

##########################################################
##########################################################

## Sinatra ##
## Based on - https://github.com/kevinhughes27/shopify-sinatra-app ##
class App < Sinatra::Base

  ##########################################################
  ##########################################################
  ##            _____              __ _                   ##
  ##           /  __ \            / _(_)                  ##
  ##           | /  \/ ___  _ __ | |_ _  __ _             ##
  ##           | |    / _ \| '_ \|  _| |/ _` |            ##
  ##           | \__/\ (_) | | | | | | | (_| |            ##
  ##            \____/\___/|_| |_|_| |_|\__, |            ##
  ##                                     __/ |            ##
  ##                                    |___/             ##
  ##########################################################
  ##########################################################

    # => Sessions
    # => Used by Rack::Flash
    # => https://github.com/nakajima/rack-flash#sinatra
    # => https://github.com/vast/sinatra-redirect-with-flash
    enable :sessions # => used by RedirectWithFlash

    # => Register
    # => This allows us to call the various extensions for the system
    register Sinatra::Shopify             # => Shopify API Management
    register Sinatra::Cors                # => Protects from unauthorized domain activity
    register Padrino::Helpers             # => number_to_currency (https://github.com/padrino/padrino-framework/blob/master/padrino-helpers/lib/padrino-helpers.rb#L22)
    register Sinatra::RespondWith         # => http://sinatrarb.com/contrib/respond_with
    register Sinatra::MultiRoute          # => Multi Route (allows for route :put, :delete)
    register Sinatra::Namespace           # => Namespace (http://sinatrarb.com/contrib/namespace.html)

    # => Helpers
    # => Allows us to manage the system at its core
    helpers Sinatra::RequiredParams     # => Required Parameters (ensures we have certain params for different routes)
    helpers Sinatra::RedirectWithFlash  # => Used to provide "flash" functionality with redirect helper

  ##########################################################
  ##########################################################

    # => Development
    # => Ensures we're only loading in development environment
    configure :development do
      register Sinatra::Reloader  # => http://sinatrarb.com/contrib/reloader
    end

  ##########################################################
  ##########################################################

  # => General
  # => Allows us to determine various specifications inside the app
  set :haml, { layout: :'layouts/application' } # https://stackoverflow.com/a/18303130/1143732
  set :views, Proc.new { File.join(root, "views") } # required to get views working (defaulted to ./views)
  set :public_folder, File.join(root, "..", "public") # Root dir fucks up (public_folder defaults to root) http://sinatrarb.com/configuration.html#root---the-applications-root-directory

  # => Required for CSRF
  # => https://cheeyeo.uk/ruby/sinatra/padrino/2016/05/14/padrino-sinatra-rack-authentication-token/
  set :protect_from_csrf, true

  ##########################################################
  ##########################################################

  # => Asset Pipeline
  # => Allows us to precompile assets as you would in Rails
  # => https://github.com/kalasjocke/sinatra-asset-pipeline#customization
  set :assets_prefix, '/dist' # => Needed to access assets in frontend
  set :assets_public_path, File.join(public_folder, assets_prefix.strip) # => Needed to tell Sprockets where to put assets
  set :assets_css_compressor, :sass
  set :assets_js_compressor,  :uglifier
  set :assets_precompile, %w[javascripts/app.js stylesheets/app.sass *.png *.jpg *.gif *.svg] # *.png *.jpg *.svg *.eot *.ttf *.woff *.woff2
  set :precompiled_environments, %i(development test staging production) # => Only precompile in staging & production

  # => Register
  # => Needs to be below definitions
  register Sinatra::AssetPipeline

  ##########################################################
  ##########################################################

  # => Sprockets
  # => This is for the layout (calling sprockets helpers etc)
  # => https://github.com/petebrowne/sprockets-helpers#setup
  configure do

    # RailsAssets
    # Required to get Rails Assets gems working with Sprockets/Sinatra
    # https://github.com/rails-assets/rails-assets-sinatra#applicationrb
    if defined?(RailsAssets)
      RailsAssets.load_paths.each do |path|
        settings.sprockets.append_path(path)
      end
    end

    # => Paths
    # => Used to add assets to asset pipeline
    %w(stylesheets javascripts images).each do |folder|
      sprockets.append_path File.join(root, 'assets', folder)
      sprockets.append_path File.join(root, '..', 'vendor', 'assets', folder)
    end

    # => Pony
    # => SMTP used to send email to account owner
    # => https://github.com/benprew/pony#default-options
    Pony.options = {
      via:  :smtp,
      via_options: {
        address: 'smtp.sendgrid.net',
        port:     '587',
        domain:   'fox-and-oak.com',
        user_name: SENDGRID_USERNAME,
        password:  SENDGRID_API_KEY,
        authentication: :plain,
        enable_starttls_auto: true
      }
    }

  end

  ##########################################################
  ##########################################################

  # => Shopify
  # => Set the scope that your app needs, read more here:
  # => http://docs.shopify.com/api/tutorials/oauth
  set :scope, 'read_products, read_orders'

  ##########################################################
  ##########################################################

  ## CORS ##
  ## Only allow requests from domain ##
  set :allow_origin,   URI::HTTPS.build(host: DOMAIN).to_s
  set :allow_methods,  "GET,POST,PUT,DELETE"
  set :allow_headers,  "accept,content-type,if-modified-since"
  set :expose_headers, "location,link"

  ##########################################################
  ##########################################################
  ##                   ___                                ##
  ##                  / _ \                               ##
  ##                 / /_\ \_ __  _ __                    ##
  ##                 |  _  | '_ \| '_ \                   ##
  ##                 | | | | |_) | |_) |                  ##
  ##                 \_| |_/ .__/| .__/                   ##
  ##                       | |   | |                      ##
  ##                       |_|   |_|                      ##
  ##########################################################
  ##########################################################

  # => App
  # => This is a simple example that fetches some products
  # => From Shopify and displays them inside your app
  get '/' do

    # => Shopify authentication
    # => Required to give us access to the information we need
    shopify_session do |shop_name|

      # => Vars
      # => Used to have a bunch of stuff, but now only @shop is declared
      @shop = Shop.find_by(name: shop_name)

      # => Show index page
      # => This allows us to expose the various objects attached to the shop
      haml :index

    end

  end ## get

  ##################################
  ##################################

  # => Options
  # => Gives us the ability to manage the options of the app (AJAX only)
  post '/options' do

    # => Shopify authentication
    # => Required to give us access to the information we need
    shopify_session do |shop_name|

      # => Vars
      # => Used to have a bunch of stuff, but now only @shop is declared
      @shop = Shop.find_by(name: shop_name).update( {pwinty_auto: false, email_notifications: false}.merge!(params.extract!(:pwinty_auto, :email_notifications)) )

      # => Show index page
      # => This allows us to expose the various objects attached to the shop
      respond_to do |format|
        format.js { status @shop ? 200 : 400 }
      end #respond_to

    end #shopify_session

  end #post

  ##########################################################
  ##########################################################
  ##            _____         _                           ##
  ##           |  _  |       | |                          ##
  ##           | | | |_ __ __| | ___ _ __ ___             ##
  ##           | | | | '__/ _` |/ _ \ '__/ __|            ##
  ##           \ \_/ / | | (_| |  __/ |  \__ \            ##
  ##            \___/|_|  \__,_|\___|_|  |___/            ##
  ##                                                      ##
  ##########################################################
  ##########################################################

  # => Orders
  # => Namespace allows us to manage the system
  namespace '/orders' do

    ##########################################################
    ##########################################################

    # => Get all orders
    # => This is used to restock the orders
    get '/?' do

      # => Shopify authentication
      # => Required to give us access to the information we need
      shopify_session do |shop_name|

        # => Vars
        # => Define the various vars for use in the route
        @shop = Shop.find_by(name: shop_name).orders.import pwinty: true

        # => Action
        # => Redirect back to index
        redirect '/', notice: "#{@shop.count} Updated"

      end #session
    end ## get

    ##########################################################
    ##########################################################

    # => Before
    # => Used for both post+get /:order_id
    before '/:order_id' do
      required_params :order_id # => Because it's a POST request, this will be contained in the headers (not the query string)
    end

    ##########################################################
    ##########################################################

    # => PDF
    # => This allows us to provide packingSlipUrl value to Pwinty
    get '/:order_id(.pdf)' do

      # => Shopify authentication
      # => Required to give us access to the information we need
      shopify_session do |shop_name|

        # => Vars
        # => Define the various vars for use in the route
        @shop  = Shop.find_by(name: shop_name)
        @order = @shop.orders.find_by number: params[:order_id]

        # => This shows the image for the packingSlipUrl
        # => To do it, we need to use ChunkyPNG to build an A4 PNG and use it to show address + line items
        content_type 'application/pdf'

        # => Emits PDF
        # => https://www.softcover.io/read/27309ccd/sinatra_cookbook/invoices
        @order.pdf.render

      end #session

    end #get

    ##########################################################
    ##########################################################

    # => PNG
    # => Needs to be accessible publicly - will need to refactor later, but will work for now
    # => This allows us to provide packingSlipUrl value to Pwinty
    get '/:order_id(.png)' do

        # => Params
        # => Requires order_primary_key param otherwise fail
        required_params :order_id, :verify # => verify is the shop's ID

        # => Vars
        # => Define the various vars for use in the route
        # => Use begin to capture raised exceptions
        begin
          @shop  = Shop.find_by! id: params[:verify] # => used to verify the route
          @order = @shop.orders.find_by! number: params[:order_id]
        rescue ActiveRecord::ActiveRecordError => e
          halt 404, "Not Found" # => show 404 page, no need to be fancy
        end

        # => This shows the image for the packingSlipUrl
        # => To do it, we need to use ChunkyPNG to build an A4 PNG and use it to show address + line items
        content_type 'image/png'

        # => Emits PDF
        # => https://www.softcover.io/read/27309ccd/sinatra_cookbook/invoices
        send_file @order.png, :type => 'image/png'

    end #get

    ##########################################################
    ##########################################################

    # => Pwinty
    # => Allows us to push order to the Pwinty API
    # => Requires address etc
    post '/:order_id' do

      ###################################
      ###################################
      # => Pwinty Gem used as API wrapper
      # => https://github.com/tomharvey/pwinty3-rb/blob/master/lib/pwinty.rb#L21
      # => MERCHANT_ID, API_KEY, BASE_URL all set via ENV vars (no need to declare them in the code)
      ###################################
      ###################################

      # => Shopify authentication
      # => Required to give us access to the information we need
      shopify_session do |shop_name|

        # => Get Order from DB
        # => This gives us acces to customer information etc
        @shop  = Shop.find_by(name: shop_name)
        @order = @shop.orders.find params[:order_id]

        # => Perform Order Request
        # => ONLY if the order has a valid set of customer information
        if @order.customer.present?

          # => Create Pwinty order for order
          # => Capture errors using the begin rescue protocol
          # => Requires recipientName, CountryCode, preferredShippingMethod
          data = (@order.try(:customer_name) != nil && @order.try(:customer_email) && @order.try(:customer_country)) ? @order.pwinty : { error: "Missing Customer Name/Email/Country" }

          # => Action
          # => Allows us to redirect to various items
          # => https://stackoverflow.com/a/2728204/1143732
          redirect '/', data

        end#if
      end #if
    end #post

    ##########################################################
    ##########################################################

  end #namespace

  ##########################################################
  ##########################################################
  ##              _____      _     _ _                    ##
  ##             | ___ \    | |   | (_)                   ##
  ##             | |_/ /   _| |__ | |_  ___               ##
  ##             |  __/ | | | '_ \| | |/ __|              ##
  ##             | |  | |_| | |_) | | | (__               ##
  ##             \_|   \__,_|_.__/|_|_|\___|              ##
  ##                                                      ##
  ##########################################################
  ##########################################################

  # => Thumbnail
  # => Gets thumbnail that can be attached to the order (front-end)
  # => May need to extract onto something else but should be okay for now
  get '/thumbnail.png' do

    # => This shows the image for the packingSlipUrl
    # => To do it, we need to use ChunkyPNG to build an A4 PNG and use it to show address + line items
    content_type 'image/png'

    # => Params
    # => This couldn't be done with a single line, unfortunately
    x = {}
    Image.keys.each { |k| x[k.downcase] = params[k.to_s] }
    x[:dark] = x.delete(:dark?) if x.has_key?(:dark?) && x.try(:[], :dark?) != nil

    # => Emits PNG
    # => https://www.softcover.io/read/27309ccd/sinatra_cookbook/invoices
    send_file Image.new(Time.now.to_i, **x.compact!).load, :type => 'image/png'

  end

  ##########################################################
  ##########################################################

  # => JPG
  # => Used to get any PNG's from image_to_send
  # => Yes, it's hacky, but it works (you'd typically set up some route in the web server to handle it)
  get '/tmp/:file(.png)' do

    # => Params
    # => Requires order_primary_key param otherwise fail
    required_params :file, :verify # => verify is the shop's ID

    # => Order
    # => The tempfile created by image_to_send will be stored as /tmp/[order_number]-[product_id].png
    # => Thus, we need to break "file" into various attriutes
    path       = request.path_info.split("_").first.split("-") # -> order_id-product_id
    order_id   = path.first.split("/").last
    product_id = path.last

    # => Vars
    # => Define the various vars for use in the route
    # => Use begin to capture raised exceptions
    begin
      @shop      = Shop.find_by! id: params[:verify] # => used to verify the route
      @order     = @shop.orders.find_by! number: order_id
      @line_item = @order.line_items.find_by! product_id: product_id
    rescue ActiveRecord::ActiveRecordError => e
      halt 404, "Not Found" # => show 404 page, no need to be fancy
    end

    # => This shows the image for the packingSlipUrl
    # => To do it, we need to use ChunkyPNG to build an A4 PNG and use it to show address + line items
    content_type 'image/png'

    # => Emits PNG
    # => https://www.softcover.io/read/27309ccd/sinatra_cookbook/invoices
    send_file @line_item.image_to_send(:load), :type => 'image/png'

  end

  ##########################################################
  ##########################################################
  ##     _    _      _     _                 _            ##
  ##    | |  | |    | |   | |               | |           ##
  ##    | |  | | ___| |__ | |__   ___   ___ | | _____     ##
  ##    | |/\| |/ _ \ '_ \| '_ \ / _ \ / _ \| |/ / __|    ##
  ##    \  /\  /  __/ |_) | | | | (_) | (_) |   <\__ \    ##
  ##     \/  \/ \___|_.__/|_| |_|\___/ \___/|_|\_\___/    ##
  ##                                                      ##
  ##########################################################
  ##########################################################

  # => Namespace
  # => Allows us to wrap the URLS with /webhook prefix
  namespace '/webhook' do

    # => Uninstall
    # => This endpoint recieves the uninstall webhook
    # => and cleans up data, add to this endpoint as your app
    # => stores more data.
    post '/uninstall' do
      shopify_webhook do |shop_name, params|
        Shop.find_by(name: shop_name).destroy # => destroy dependents
      end
    end

    # => Order
    # => Endpoint receives the "orders/create" webhook
    # => Allows us to create new order within the system
    post '/order' do
      shopify_webhook do |shop_name, params|
        Shop.find_by(name: shop_name).orders.import params # => send the data through to the system # TODO add global "pwinty_on_import option, to determine if Pwinty is triggered on webhook inbounds"
      end
    end

  end

  ##########################################################
  ##########################################################

  private

  # => Post Install/Uninstall
  # => This method gets called when your app is installed.
  # => setup any webhooks or services you need on Shopify
  # => inside here.
  def after_shopify_auth
    shopify_session do |shop_name| # => Shopify hook

    ##################################################
    ##################################################

      ## Email ##
      ## Populates email for shop admin ##
      ## Only needs to be updated once ##
      @shop = Shop.find_by(name: shop_name)
      @shop.update({email: ShopifyAPI::Shop.current.email}) unless @shop.email.present?

    ##################################################
    ##################################################

      ############################################################
      ## //////////////// Uninstall Webhook /////////////////// ##
      ############################################################
      ## Used to remove the shop/store after removal in Shopify ##
      ############################################################

      # => Allows us to remove the app from the db when it's installed from shopify
      begin
        uninstall_webhook = ShopifyAPI::Webhook.create(
          topic: 'app/uninstalled',
          address: "#{base_url}/webhook/uninstall",
          format: 'json'
        )
      rescue => e
        raise unless uninstall_webhook.persisted?
      end

      ############################################################
      ## /////////////////// Order Webhook //////////////////// ##
      ############################################################
      ##   Gets order info any time one is placed in Shopify    ##
      ############################################################

      begin
        order_webhook = ShopifyAPI::Webhook.create(
          topic: 'orders/create',
          address: "#{base_url}/webhook/order",
          format: 'json'
        )
      rescue => e
        raise unless order_webhook.persisted?
      end

    ##################################################
    ##################################################

    end ## session
  end ## auth
end ## app.rb

##########################################################
##########################################################
