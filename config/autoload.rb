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

# => Load
# => This replaces individual requires with bundled gems
# => https://stackoverflow.com/a/1712669/1143732
require 'bundler'

# => Pulls in all Gems
# => Replaces the need for individual gems
Bundler.require :default, ENV.fetch("RACK_ENV", "development") if defined?(Bundler) # => ENVIRONMENT only used here, can do away with constant if necessary

##################################################
##################################################

## Zeitwerk ##
## This should really have bundler stuff ##
## https://www.oreilly.com/library/view/sinatra-up-and/9781449306847/ch04.html ##
loader = Zeitwerk::Loader.new
%w(app/controllers app/models app/helpers app/drops app/tags lib config).each do |d|
  loader.push_dir(d)
end
loader.enable_reloading # you need to opt-in before setup
loader.inflector.inflect "omniauth" => "OmniAuth" # required to get the custom hmrc strategy to load
loader.inflector.inflect "hmrc"     => "HMRC"     # required to get the custom hmrc strategy to load
loader.setup

##################################################
##################################################

## ExecJS (RPECK 16/01/2020) ##
## This was required locally because Ruby 3.0.0 messed up the way in which File.open is called (the following file is changed on line 178) ##
require_relative '../lib/execjs/external_runtime' if Gem.win_platform?

##################################################
##################################################

# => Eager Loading
# => This is required to mitigate a number of conflicts/errors due to the eager loading at the end of the file
# => I had to include eager loading because of the way in which Liquid needed to load tags globally (which was not happening without the eager load)
%w(../lib/execjs ../config/deploy).each do |path|
  loader.ignore("#{__dir__}/#{path}")
end

##################################################
##################################################

# => Base
# => This is used to give us a general set of config options
# => No, it's not the simplest way to do it, but it works
class Autoload < Sinatra::Base

    # => Register
    # => This allows us to call the various extensions for the system
    register Sinatra::Auth                  # => My own Warden implementation extracted into a Sinatra module (./lib/sinatra/auth.rb)
    register Sinatra::Cors                  # => Protects from unauthorized domain activity
    register Sinatra::OmniAuth              # => This is my own implementation of several routes which are required for omniauth. SHOULD BE MOVED ELSEWHERE
    register Sinatra::Hooks                 # => lib/sinatra/hooks (allows us to use Wordpress-style hooks)
    register Padrino::Helpers               # => number_to_currency (https://github.com/padrino/padrino-framework/blob/master/padrino-helpers/lib/padrino-helpers.rb#L22)
    register Sinatra::RespondWith           # => http://sinatrarb.com/contrib/respond_with
    register Sinatra::MultiRoute            # => Multi Route (allows for route :put, :delete)
    register Sinatra::Namespace             # => Namespace (http://sinatrarb.com/contrib/namespace.html)
    register Sinatra::I18nSupport           # => Locales (https://www.rubydoc.info/gems/sinatra-support/1.2.2/Sinatra/I18nSupport) -- dependent on sinatra-support gem (!)
    register Sinatra::ActiveRecordExtension # => Required to use the ActiveRecord extension for Sinatra

    # => Rack (Flash/Sessions etc)
    # => Allows us to use the "flash" object (rack-flash3)
    # => Required to get redirect_with_flash working
    use Rack::Deflater # => Compresses responses generated at server level
    use Rack::Session::Cookie, secret: ENV.fetch("SECRET", "62uao31c7d7j7dy6se9hs5auxyupmay") # => could use enable :sessions instead (http://sinatrarb.com/faq.html#sessions)
    use Rack::Flash, accessorize: [:notice, :error], sweep: true
    use Rack::MethodOverride # => used for DELETE requests (logout etc) - https://stackoverflow.com/a/5169913 // http://sinatrarb.com/configuration.html#method_override---enabledisable-the-post-_method-hack

    # => OmniAuth
    # => This allows us to build the various providers required for connecting with Omniauth
    # => https://gist.github.com/gorenje/2895009/87ca24478ee19eb7bfa557b98221a177d714e16c
    use OmniAuth::Builder do
      provider :hmrc_vat, ENV.fetch("HMRC_CLIENT_ID"), ENV.fetch("HMRC_CLIENT_SECRET")
    end

    # => HTMLCompressor
    # => Used to minify HTML output (removes bloat and other nonsense)
    unless settings.development?
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
    end

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
    set :root, File.join(Dir.pwd, "app") # => had to change because we put into the app/controllers directory (if we put it in app directory we can just use default behaviour)
    set :views, File.join(root, 'views') # => required to get views working (defaulted to ./views)
    set :public_folder, File.join(root, "..", "public") # => Root dir fucks up (public_folder defaults to root) http://sinatrarb.com/configuration.html#root---the-applications-root-directory
    set :domain, ENV.fetch('DOMAIN', 'vat-mtd.herokuapp.com') # => Allows us to define the domain in the app's settings

    # => Required for CSRF
    # => https://cheeyeo.uk/ruby/sinatra/padrino/2016/05/14/padrino-sinatra-rack-authentication-token/
    set :protect_from_csrf, true

    # => Locales
    # => This had to be included to ensure we can use the various locales required by Auth + others
    load_locales File.join(root, "..", "config", "locales") # => requires Sinatra::I18nSupport

  ##########################################################
  ##########################################################

    # => Terser
    # => Quicker/better than Uglifier and supports ES6 (RPECK 16/01/2021)
    Sprockets.register_compressor 'application/javascript', :terser, Terser::Compressor

    # => Asset Pipeline
    # => Allows us to precompile assets as you would in Rails
    # => https://github.com/kalasjocke/sinatra-asset-pipeline#customization
    set :assets_prefix, '/dist' # => Needed to access assets in frontend
    set :assets_public_path, File.join(public_folder, assets_prefix.strip) # => Needed to tell Sprockets where to put assets
    set :assets_css_compressor, :sass
    set :assets_js_compressor,  :terser
    set :assets_precompile, %w[app.coffee app.sass *.png *.jpg *.gif *.svg] # *.png *.jpg *.svg *.eot *.ttf *.woff *.woff2
    set :precompiled_environments, %i(staging production) # => Only precompile in staging & production

    # => SMTP Settings
    # => Allows us to define the various parts of the system - we use SendGrid as a default
    set :smtp_host,           ENV.fetch('SMTP_HOST', 'smtp.sendgrid.net')
    set :smtp_port,           ENV.fetch('SMTP_PORT', '587')
    set :smtp_user,           ENV.fetch('SMTP_USER', 'apikey')
    set :smtp_password,       ENV.fetch('SMTP_PASS', nil)
    set :smtp_authentication, ENV.fetch('SMTP_AUTH', :plain)
    set :smtp_starttls,       ENV.fetch('SMTP_STARTTLS', true)

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

      # => Pony
      # => SMTP used to send email to account owner
      # => https://github.com/benprew/pony#default-options
      Pony.options = {
        via: :smtp,
        via_options: {
          address:              settings.smtp_host,
          port:                 settings.smtp_port,
          domain:               settings.domain,
          user_name:            settings.smtp_user,
          password:             settings.smtp_password,
          authentication:       settings.smtp_authentication,
          enable_starttls_auto: settings.smtp_starttls
        }
      } #pony

    end #configure

  ##########################################################
  ##########################################################

    ## CORS ##
    ## Only allow requests from domain ##
    set :allow_origin,   URI::HTTPS.build(host: settings.domain).to_s
    set :allow_methods,  "GET,POST,PUT,DELETE"
    set :allow_headers,  "accept,content-type,if-modified-since"
    set :expose_headers, "location,link"

  ##############################################################
  ##############################################################

    # => Errors
    # => https://blog.iphoting.com/blog/2012/04/22/custom-404-error-pages-with-sinatra-dot-rb/
    # => https://github.com/vast/sinatra-redirect-with-flash
    # => https://stackoverflow.com/questions/25299186/sinatra-error-handling-in-ruby
    error 400..510 do
      respond_with :index, name: "error" do |format|
        format.js   { {error: env['sinatra.error'].class.name.demodulize }.to_json }
        format.html { redirect "/", error: env['sinatra.error'].class.name.demodulize }
      end
    end

  ##############################################################
  ##############################################################

end

##########################################################
##########################################################

# => Eagerload
# => This is used to laod the files that are required to run the app (I had to do this so the Liquid::Template could be registered)
loader.eager_load # => required to get the Liquid Tags to register globally (otherwise would have to do it manually for each one)

##########################################################
##########################################################
