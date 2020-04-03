##########################################################
##########################################################
##        _    _____  ______    __  _____________       ##
##       | |  / /   |/_  __/   /  |/  /_  __/ __ \      ##
##       | | / / /| | / /_____/ /|_/ / / / / / / /      ##
##       | |/ / ___ |/ /_____/ /  / / / / / /_/ /       ##
##       |___/_/  |_/_/     /_/  /_/ /_/ /_____/        ##
##                                                      ##
##########################################################
##########################################################
##              Main Sinatra app.rb file                ##
## Allows us to define, manage and serve various routes ##
##########################################################
##########################################################
## Tool to provide VAT-MTD integration for anyone using ##
## spreadsheets to submit their VAT returns online.     ##
##########################################################
##########################################################

# => Constants
# => Should be loaded by Bundler, but this has to do for now
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
require_all 'app'

##########################################################
##########################################################

## Sinatra ##
## Based on - https://github.com/kevinhughes27/shopify-sinatra-app ##
class App < Sinatra::Base

  ##########################################################
  ##########################################################
  ##              ______            _____                 ##
  ##             / ____/___  ____  / __(_)___ _           ##
  ##            / /   / __ \/ __ \/ /_/ / __ `/           ##
  ##           / /___/ /_/ / / / / __/ / /_/ /            ##
  ##           \____/\____/_/ /_/_/ /_/\__, /             ##
  ##                                  /____/              ##
  ##########################################################
  ##########################################################

    # => Register
    # => This allows us to call the various extensions for the system
    register Sinatra::Cors                # => Protects from unauthorized domain activity
    register Padrino::Helpers             # => number_to_currency (https://github.com/padrino/padrino-framework/blob/master/padrino-helpers/lib/padrino-helpers.rb#L22)
    register Sinatra::RespondWith         # => http://sinatrarb.com/contrib/respond_with
    register Sinatra::MultiRoute          # => Multi Route (allows for route :put, :delete)
    register Sinatra::Namespace           # => Namespace (http://sinatrarb.com/contrib/namespace.html)
    register Sinatra::I18nSupport         # => Locales (https://www.rubydoc.info/gems/sinatra-support/1.2.2/Sinatra/I18nSupport) -- dependent on sinatra-support gem (!)
    register Sinatra::Initializers        # => Initializers (used to give "meta" model support)

    # => Rack (Flash/Sessions etc)
    # => Allows us to use the "flash" object (rack-flash3)
    # => Required to get redirect_with_flash working
    use Rack::Deflater # => Compresses responses generated at server level
    use Rack::Session::Cookie, secret: SECRET # => could use enable :sessions instead (http://sinatrarb.com/faq.html#sessions)
    use Rack::Flash, accessorize: [:notice, :error], sweep: true
    use Rack::MethodOverride # => used for DELETE requests (logout etc) - https://stackoverflow.com/a/5169913 // http://sinatrarb.com/configuration.html#method_override---enabledisable-the-post-_method-hack

    # => HTMLCompressor
    # => Used to minify HTML output (removes bloat and other nonsense)
    use HtmlCompressor::Rack,
      compress_css: false,        # => already done by webpack
      compress_javascript: false, # => already done by webpack
      enabled: true,
      preserve_line_breaks: false,
      remove_comments: true,
      remove_form_attributes: false,
      remove_http_protocol: false,
      remove_https_protocol: false,
      remove_input_attributes: true,
      remove_intertag_spaces: true,
      remove_javascript_protocol: true,
      remove_link_attributes: true,
      remove_multi_spaces: true,
      remove_quotes: true,
      remove_script_attributes: true,
      remove_style_attributes: true,
      simple_boolean_attributes: true,
      simple_doctype: false

    # => Helpers
    # => Allows us to manage the system at its core
    helpers Sinatra::RequiredParams     # => Required Parameters (ensures we have certain params for different routes)
    helpers Sinatra::RedirectWithFlash  # => Used to provide "flash" functionality with redirect helper

    # => Includes
    # => Functionality provided by various systems (some my own)
    include Auth # => app/auth.rb (used for Warden)

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

    # => Logger
    # => Allows us to store information from the application
    # => http://sinatrarb.com/contrib/custom_logger
    configure :development, :production do
      FileUtils.touch "#{root}/../log/#{environment}.log"
      logger = Logger.new File.open("#{root}/../log/#{environment}.log", 'a') # => https://code-maven.com/how-to-write-to-file-in-ruby
      set :logger, logger
    end

    # => Required for CSRF
    # => https://cheeyeo.uk/ruby/sinatra/padrino/2016/05/14/padrino-sinatra-rack-authentication-token/
    set :protect_from_csrf, true

    # => Locales
    # => This had to be included to ensure we can use the various locales required by Auth + others
    load_locales File.join(root, "..", "config", "locales") # => requires Sinatra::I18nSupport

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
    set :precompiled_environments, %i(staging production) # => Only precompile in staging & production

    # => Register
    # => Needs to be below definitions
    register Sinatra::AssetPipeline

  ##########################################################
  ##########################################################

    # => Sprockets
    # => This is for the layout (calling sprockets helpers etc)
    # => https://github.com/petebrowne/sprockets-helpers#setup
    configure do

      # => RailsAssets
      # => Required to get Rails Assets gems working with Sprockets/Sinatra
      # => https://github.com/rails-assets/rails-assets-sinatra#applicationrb
      RailsAssets.load_paths.each { |path| settings.sprockets.append_path(path) } if defined?(RailsAssets)

      # => Gems
      # => Any gems in the "assets" group need to be loaded
      Bundler.load.current_dependencies.select{|dep| dep.groups.include?(:assets) }.map(&:name).each do |gem| # => https://stackoverflow.com/a/35183285/1143732
        %w[stylesheets javascripts].each do |item|
          sprockets.append_path File.join(Bundler.rubygems.find_name(gem).first.full_gem_path, 'vendor', 'assets', item)
          sprockets.append_path File.join(Bundler.rubygems.find_name(gem).first.full_gem_path, 'app', 'assets', item)
        end
      end

      # => Paths
      # => Used to add assets to asset pipeline
      %w(stylesheets javascripts images).each do |folder|
        sprockets.append_path File.join(root, 'assets', folder)
        sprockets.append_path File.join(root, '..', 'vendor', 'assets', folder)
      end #paths

      # => Pony
      # => SMTP used to send email to account owner
      # => https://github.com/benprew/pony#default-options
      Pony.options = {
        via: :smtp,
        via_options: {
          address:  'smtp.sendgrid.net',
          port:     '587',
          domain:    DOMAIN,
          user_name: 'apikey',
          password:  ENV.fetch('SENDGRID'),
          authentication: :plain,
          enable_starttls_auto: true
        }
      } #pony

    end #configure

  ##########################################################
  ##########################################################

    ## CORS ##
    ## Only allow requests from domain ##
    set :allow_origin,   URI::HTTPS.build(host: DOMAIN).to_s
    set :allow_methods,  "GET,POST,PUT,DELETE"
    set :allow_headers,  "accept,content-type,if-modified-since"
    set :expose_headers, "location,link"

  ##############################################################
  ##############################################################

    ## APP ##
    ## Allows us to set specifics for ENTIRE app
    before do

      # => Options
      # => Used to provide base functionality for the likes of app title etc
      @options = OpenStruct.new title: Option.find_by(user_id: 0, ref: "app_title").try(:val)

      # => Authentication
      # => Allows you to load the page if required
      # => https://stackoverflow.com/a/7709087/1143732
      env['warden'].authenticate! unless %w[login logout register].include?(request.path_info.split('/')[1]) || !request.path_info.split('/')[1].nil? # => required to ensure protection // https://stackoverflow.com/a/7709087/1143732

    end

  ##############################################################
  ##############################################################
  ##     ____             __    __                         __ ##
  ##    / __ \____ ______/ /_  / /_  ____  ____ __________/ / ##
  ##   / / / / __ `/ ___/ __ \/ __ \/ __ \/ __ `/ ___/ __  /  ##
  ##  / /_/ / /_/ (__  ) / / / /_/ / /_/ / /_/ / /  / /_/ /   ##
  ## /_____/\__,_/____/_/ /_/_.___/\____/\__,_/_/   \__,_/    ##
  ##                                                          ##
  ##############################################################
  ##############################################################
  ## This is the central "management" page that is shown to the user
  ## It needs to include authentication to give them the ability to access it
  ##############################################################
  ##############################################################

  # => Dash
  # => Shows Nodes/Databases the user has created
  # => Required authentication
  get '/' do

    # => Objects
    # => @pages = the pages of current_user
    @nodes = current_user.nodes

    # => Action
    # => Show the "index" page (app/views/index.haml)
    haml :index

  end ## get

  ############################################################
  ############################################################
  ##                _   __          __                      ##
  ##               / | / /___  ____/ /__  _____             ##
  ##              /  |/ / __ \/ __  / _ \/ ___/             ##
  ##             / /|  / /_/ / /_/ /  __(__  )              ##
  ##            /_/ |_/\____/\__,_/\___/____/               ##
  ##                                                        ##
  ############################################################
  ############################################################
  ## Central data object in system (allows us to store data payload + appended data)
  ## Allows us to move pages around with content etc @node.contents
  ############################################################
  ############################################################

  # => Namespace
  # => Gives us the means to create & manage nodes as required
  namespace :nodes do

    ################################
    ################################

    # => New
    # => Provide functionality for building a new node (IE able to add properties etc)
    # => This is somewhat experimental, but still pretty damn cool
    get 'new' do
      @node = current_user.nodes.new # => allows us to create new nodes
    end ## get

    ################################
    ################################

    # => Create
    # => Build the new node + properties required to make it work
    post 'create' do
      @node = current_user.nodes.create node_params
    end

    ################################
    ################################

  end ## namespace

  ##############################################################
  ##############################################################

end ## app.rb

##########################################################
##########################################################
