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

    #########################
    #########################

    # => Helpers
    # => Made available in the frontend
    module Helpers

      # => Current User
      # => Returns @user object for currently logged in user
      def current_user
        env['warden'].user # => https://github.com/wardencommunity/warden/wiki/Users#accessing-a-user
      end #current_user

      # => Logged in?
      # => User Logged In?
      def user_signed_in?
        !env['warden'].user.nil?
      end #user_signed_in

    end #module

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
        app.set :auth_login,    "login"
        app.set :auth_logout,   "logout"
        app.set :auth_register, "register"
        app.set :auth_unauth,   "unauthenticated"

      ###################################
      ###################################

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
            action: app.settings.auth_unauth
          # When a user tries to log in and cannot, this specifies the
          # app to send the user to.
          config.failure_app = self

        end

      ###################################
      ###################################

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

        ###################################
        ###################################

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
        app.before %r{\/(#{app.settings.auth_login}|#{app.settings.auth_register}|#{app.settings.auth_unauth})} do
          redirect "/", notice: I18n.t('auth.login.persisted') if user_signed_in?
        end

        ##########################################################
        ##########################################################

        # => Login (GET)
        # => Standard login form (no need to set anything except the HTML elements)
        # => Need to ensure users are redirected to index if they are logged in
        app.get "/#{app.settings.auth_login}" do
          haml :'auth/login'
        end

        # => Login (POST)
        # => Where the login form submits to (allows us to process the request)
        app.post "/#{app.settings.auth_login}" do
          env['warden'].authenticate!
          redirect (session[:return_to].nil? ? '/' : session[:return_to]), notice: I18n.t('auth.login.success')
        end

        # => Logout (GET)
        # => Request to log out of the system (allows us to perform session destroy)
        app.delete "/#{app.settings.auth_logout}" do
          env['warden'].logout
          redirect '/', error: I18n.t('auth.logout.success')
        end

        # => Unauthenticated (POST)
        # => Where to send the user if they are not authorized to view a page (IE they hit a page, and it redirects them to the unauthorized page)
        app.post "/#{app.settings.auth_unauth}" do
          session[:return_to] ||= env['warden.options'][:attempted_path]
          redirect "/#{settings.login}", error: env['warden.options'][:message] || I18n.t('auth.login.failure')
        end

        #############################################
        #############################################

        # => Register
        # => Allows us to accept users into the application
        app.get "/#{app.settings.auth_register}" do
          @user = User.new
          haml :'auth/register'
        end

        # => Register (POST)
        # => Create the user from the sent items
        app.post "/#{app.settings.auth_register}" do
          required_params :user # => ensure we have the :user param set
          @user = User.new params.dig("user")
          if @user.save
            env['warden'].set_user(@user)
            redirect "/", notice: I18n.t('auth.login.success')
          else
            haml :'auth/register'
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
