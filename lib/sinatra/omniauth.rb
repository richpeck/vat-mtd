##########################################################
##########################################################
##      ____                  _ ___         __  __      ##
##     / __ \____ ___  ____  (_)   | __  __/ /_/ /_     ##
##    / / / / __ `__ \/ __ \/ / /| |/ / / / __/ __ \    ##
##   / /_/ / / / / / / / / / / ___ / /_/ / /_/ / / /    ##
##   \____/_/ /_/ /_/_/ /_/_/_/  |_\__,_/\__/_/ /_/     ##
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
  module OmniAuth

    # => Registered
    # => http://sinatrarb.com/extensions.html
    def self.registered(app)

      ###################################
      ###################################

      # => oAuth
      # => This is from https://github.com/omniauth/omniauth/wiki/Sinatra-Example
      app.get '/auth/:name/callback' do

        # => Auth object (data)
        # => Structure credentials: { expires_at: x, token: y, refresh_token: z}
        auth = request.env['omniauth.auth']

        # => Update
        # => This updates the user so that we're able to access the token/refresh token in future
        current_user.access_token         = auth['credentials']['token']
        current_user.refresh_token        = auth['credentials']['refresh_token']
        current_user.access_token_expires = Time.at(auth['credentials']['expires_at'])
        current_user.save

        # => Action
        # => Redirect to homepage
        redirect "/", notice: "Authenticated, thank you"

      end #get

      ##############################################################
      ##############################################################

      # => oAuth Failure
      # => Apparently will send failure messages to this address
      app.get '/auth/failure' do
        redirect '/', notice: params[:message]
      end #get

      ##############################################################
      ##############################################################

      # => Revoke
      # => This is from https://github.com/omniauth/omniauth/wiki/Sinatra-Example
      app.delete '/auth/hmrc_vat/revoke' do

        # => Current User
        # => Basically, there is no way to revoke token access via the API
        # => This means we need to handle the revokation by faking it
        current_user.access_token         = ''
        current_user.refresh_token        = ''
        current_user.access_token_expires = ''
        current_user.save

        # => Returns
        # => This data is not required when we don't have access to HMRC any more
        current_user.returns.destroy_all

        # => Action
        # => Redirect to homepage
        redirect "/", notice: "Revoked"

      end #delete

      ##############################################################
      ##############################################################

    end #registered
  end #auth

  # => Register
  # => Allows us to integrate into the Sinatra app
  register OmniAuth

  ##########################################################
  ##########################################################

end#sinatra
