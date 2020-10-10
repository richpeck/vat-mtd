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

# => Auth
require_relative '../lib/warden'

##########################################################
##########################################################

# => Base
# => This is used to give us a general set of config options
# => No, it's not the simplest way to do it, but it works
class Config < Sinatra::Base

    # => Register
    # => This allows us to call the various extensions for the system
    register Sinatra::Cors                # => Protects from unauthorized domain activity
    register Padrino::Helpers             # => number_to_currency (https://github.com/padrino/padrino-framework/blob/master/padrino-helpers/lib/padrino-helpers.rb#L22)
    register Sinatra::RespondWith         # => http://sinatrarb.com/contrib/respond_with
    register Sinatra::MultiRoute          # => Multi Route (allows for route :put, :delete)
    register Sinatra::Namespace           # => Namespace (http://sinatrarb.com/contrib/namespace.html)
    register Sinatra::I18nSupport         # => Locales (https://www.rubydoc.info/gems/sinatra-support/1.2.2/Sinatra/I18nSupport) -- dependent on sinatra-support gem (!)

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

    # => Staging
    # => Manage staging environment to ensure the system is protected from unwanted attention
    configure :staging do
      use Rack::Attack # => allows us to block access etc
      Rack::Attack.safelist_ip("86.22.69.208")
      Rack::Attack.blocklist("block all access") { |request| request.path.start_with? "/" }
    end

    # => Logging
    # => Enable logging for production & development
    # => https://nickcharlton.net/posts/structuring-sinatra-applications.html
    configure :production do
      enable :logging
    end

  ##########################################################
  ##########################################################

    # => General
    # => Allows us to determine various specifications inside the app
    set :haml, { layout: :'layouts/application' } # https://stackoverflow.com/a/18303130/1143732
    set :root, File.join(Dir.pwd, "app") # => had to change because we put into the app/controllers directory (if we put it in app directory we can just use default behaviour)
    set :views, File.join(root, 'views') # => required to get views working (defaulted to ./views)
    set :public_folder, File.join(root, "..", "public") # => Root dir fucks up (public_folder defaults to root) http://sinatrarb.com/configuration.html#root---the-applications-root-directory

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

    # => Config
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
      %w(stylesheets javascripts images fonts).each do |folder|
        sprockets.append_path File.join(root, 'assets', folder)
        sprockets.append_path File.join(root, '..', 'vendor', 'assets', folder)
      end #paths

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

      # => Authentication
      # => Allows you to load the page if required
      # => https://stackoverflow.com/a/7709087/1143732
      env['warden'].authenticate! unless %w[nil login logout register unauthenticated].include?(request.path_info.split('/')[1]) # => https://stackoverflow.com/a/7709087/1143732

    end

  ##############################################################
  ##############################################################

    # => Errors
    # => https://blog.iphoting.com/blog/2012/04/22/custom-404-error-pages-with-sinatra-dot-rb/
    # => https://github.com/vast/sinatra-redirect-with-flash
    # => https://stackoverflow.com/questions/25299186/sinatra-error-handling-in-ruby
    error 400..510 do
      respond_with :index, name: "test" do |format|
        format.js   { {error: env['sinatra.error'].class.name.demodulize }.to_json }
        format.html { redirect "/", error: env['sinatra.error'].class.name.demodulize }
      end
    end

  ##############################################################
  ##############################################################

end
