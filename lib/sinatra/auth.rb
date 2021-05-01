##########################################################
##########################################################
##         _       __               __                  ##
##        | |     / /___ __________/ /__  ____          ##
##        | | /| / / __ `/ ___/ __  / _ \/ __ \         ##
##        | |/ |/ / /_/ / /  / /_/ /  __/ / / /         ##
##        |__/|__/\__,_/_/   \__,_/\___/_/ /_/          ##
##                                                      ##
##########################################################
##########################################################
## This is directly added to the "app.rb" file -- could be put in either /lib or /auth
## In order to get it working properly, we need to ensure we have included the file appropriately
## --
## Think of this as a means to extract functionality from the base app.rb
## https://github.com/sklise/sinatra-warden-example
##########################################################
##########################################################

## Sinatra ##
## Required to run our system ##
module Sinatra

  ##########################################################
  ##########################################################

  # => Included
  # => May need to change the name of the file
  module Auth

    # => References
    # => https://github.com/wardencommunity/sinatra_warden
    # => https://github.com/jondot/padrino-warden

    #########################
    #########################

    # => Helpers
    # => Made available in the frontend
    module Helpers

      # => Warden
      # => Calls the Warden object and allows us to manipulate it through the "warden" method name
      # => https://github.com/wardencommunity/sinatra_warden/blob/master/lib/sinatra_warden/sinatra.rb#L7
      def warden
        env['warden']
      end #warden

      # => Authenticate
      # => Authenticate a user against defined strategies
      # => https://github.com/wardencommunity/sinatra_warden/blob/master/lib/sinatra_warden/sinatra.rb#L25
      def authenticate(*args)
        warden.authenticate(*args)
      end #authenticate
      alias_method :login, :authenticate
      alias_method :authenticate!, :authenticate

      # => User
      # => Returns @user object for currently logged in user
      def user(scope=nil)
        scope ? warden.user(scope) : warden.user
      end #user
      alias_method :current_user, :user

      # => User
      # Store the logged in user in the session
      #
      # @param [Object] the user you want to store in the session
      # @option opts [Symbol] :scope The scope to assign the user
      # @example Set John as the current user
      # user = User.find_by_name('John')
      def user=(new_user, opts={})
        warden.set_user(new_user, opts)
      end
      alias_method :current_user=, :user=

      # => Logged in?
      # => User Logged In?
      def user_signed_in?
        !warden.user.nil?
      end #user_signed_in

      # => Logout
      # => https://github.com/wardencommunity/sinatra_warden/blob/master/lib/sinatra_warden/sinatra.rb#L33
      def logout(scopes=nil)
        scopes ? warden.logout(scopes) : warden.logout(warden.config.default_scope)
      end

    end #helpers

    #########################
    #########################

    # => Registered
    # => http://sinatrarb.com/extensions.html
    def self.registered(app)

      ###################################
      ###################################

        # => Helpers
        # => Allow us to call the various helper methods inside the app
        # => http://sinatrarb.com/extensions.html#setting-options-and-other-extension-setup
        app.helpers Auth::Helpers

        # => Settings
        # => Allows us to override the settings if necessary
        app.set :auth, {
            'login'    => 'login',
            'logout'   => 'logout',
            'register' => 'register',
            'unauth'   => 'unauth'
        }

      ###################################
      ###################################

        # => Authentication
        # => Allows you to load the page if required
        # => https://stackoverflow.com/a/7709087/1143732
        app.before do
          authenticate! unless %w[nil login logout register unauthenticated privacy terms].include?(request.path_info.split('/')[1]) # => https://stackoverflow.com/a/7709087/1143732
        end

        # => Warden
        # => This allows us to manage authentication within the app
        # => https://github.com/sklise/sinatra-warden-example#apprb-cont
        app.use Warden::Manager do |config|

          # Tell Warden how to save our User info into a session.
          # Sessions can only take strings, not Ruby code, we'll store
          # the User's `id`
          config.serialize_into_session{|user| user.id }

          # Now tell Warden how to take what we've stored in the session
          # and get a User from that information.
          config.serialize_from_session do |id|
            begin
              User.find(id)
            rescue
              env['warden'].logout
            end
          end

          config.scope_defaults :default,
            # "strategies" is an array of named methods with which to
            # attempt authentication. We have to define this later.
            strategies: [:password],
            # The action is a route to send the user to when
            # warden.authenticate! returns a false answer. We'll show
            # this route below.
            action: app.auth['unauth']
          # When a user tries to log in and cannot, this specifies the
          # app to send the user to.
          config.failure_app = app

        end

        # => Failure Manager
        # => Allows us to consider how the system should work
        Warden::Manager.before_failure do |env,opts|

          # Because authentication failure can happen on any request but
          # we handle it only under "post '/auth/unauthenticated'", we need
          # to change request to POST
          env['REQUEST_METHOD'] = 'POST'

          # And we need to do the following to work with  Rack::MethodOverride
          env.each do |key, value|
            env[key]['_method'] = 'post' if key == 'rack.request.form_hash'
          end

        end

        # => Strategies
        # => Password allows us to manage the system
        Warden::Strategies.add(:password) do
          def valid?
            params['user'] && params['user']['email'] && params['user']['password']
          end

          def authenticate!
            user = User.find_by email: params['user']['email'] # => email is unique, so any records will be the only record

            if user.nil?
              throw(:warden, message: "Email does not exist")
            elsif user.authenticate(params['user']['password'])
              user.update last_signed_in_at: Time.now, last_signed_in_ip: request.ip
              success!(user)
            else
              throw(:warden, message: "Bad password")
            end
          end
        end

        ##########################################################
        ##########################################################
        ##             ____              __                     ##
        ##            / __ \____  __  __/ /____  _____          ##
        ##           / /_/ / __ \/ / / / __/ _ \/ ___/          ##
        ##          / _, _/ /_/ / /_/ / /_/  __(__  )           ##
        ##         /_/ |_|\____/\__,_/\__/\___/____/            ##
        ##                                                      ##
        ##########################################################
        ##########################################################

        # => Before
        # => Prevent auth pages showing when logged in
        # => https://stackoverflow.com/a/17912053/1143732
        app.before %r{\/(#{app.settings.auth[:login]}|#{app.settings.auth[:register]}|#{app.settings.auth[:unauth]})} do
          redirect "/", notice: I18n.t('auth.login.persisted') if user_signed_in?
        end

        ##########################################################
        ##########################################################

        # => Login (GET)
        # => Standard login form (no need to set anything except the HTML elements)
        # => Need to ensure users are redirected to index if they are logged in
        app.get "/#{app.auth[:login]}" do # => https://github.com/jondot/padrino-warden/blob/master/lib/padrino/warden/controller.rb#L22
          perform_hook :pre_render, haml(:'auth/login')
        end

        # => Login (POST)
        # => Where the login form submits to (allows us to process the request)
        app.post "/#{app.auth[:login]}" do
          authenticate!
          redirect (session[:return_to].nil? ? '/' : session[:return_to]), notice: I18n.t('auth.login.success')
        end

        # => Logout (GET)
        # => Request to log out of the system (allows us to perform session destroy)
        app.delete "/#{app.auth[:logout]}" do
          warden.logout
          redirect '/', error: I18n.t('auth.logout.success')
        end

        # => Unauthenticated (POST)
        # => Where to send the user if they are not authorized to view a page (IE they hit a page, and it redirects them to the unauthorized page)
        app.post "/#{app.auth[:unauth]}" do
          session[:return_to] ||= env['warden.options'][:attempted_path]
          redirect "/#{app.auth[:login]}", error: env['warden.options'][:message] || I18n.t('auth.login.failure')
        end

        #############################################
        #############################################

        # => Register
        # => Allows us to accept users into the application
        app.get "/#{app.auth[:register]}" do
          @user = User.new
          perform_hook :pre_render, haml(:'auth/register')
        end

        # => Register (POST)
        # => Create the user from the sent items
        app.post "/#{app.auth[:register]}" do
          required_params :user # => ensure we have the :user param set
          @user = User.new params.dig("user")
          if @user.save
            warden.set_user(@user)
            redirect "/", notice: I18n.t('auth.login.success')
          else
            perform_hook :pre_render, haml(:'auth/register')
          end
        end

        #############################################
        #############################################

    end #included
  end #auth

  # => Register
  # => Allows us to integrate into the Sinatra app
  register Auth

  ##########################################################
  ##########################################################

end#sinatra
