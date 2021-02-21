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

# => Dashboard
# => Referenced in ./config.ru
class ApplicationController < Environment # => /config/settings.rb (wanted to include everything in Sinatra::Base, but looks like I have to subclass it for now)

  # => Helpers
  # => Allows us to call helpers as required
  # => https://stackoverflow.com/a/7642637/1143732
  helpers ApplicationHelper

  ##############################################################
  ##############################################################

  # => General
  # => Pulls pages (some are static and need to be shown outside of the authentication system)
  get '/', '/:id' do

    # Set ID
    # This is set if no :id is passed (IE the user is on the index page)
    params[:id] ||= :index

    # => Vars
    # => Required for certain views
    @columns = Return.attribute_names - %w(id user_id updated_at) if params[:id] == :index

    # => Action
    # => Needs to be updated for the pages
    haml params[:id]

  end

  ##############################################################
  ##############################################################
  ##                     ___         __  __                   ##
  ##              ____  /   | __  __/ /_/ /_                  ##
  ##             / __ \/ /| |/ / / / __/ __ \                 ##
  ##            / /_/ / ___ / /_/ / /_/ / / /                 ##
  ##            \____/_/  |_\__,_/\__/_/ /_/                  ##
  ##                                                          ##
  ##############################################################
  ##############################################################
  ## Allows for OmniAuth gem to perform various tasks
  ## This was originally in its own controller, but that interfered with the OmniAuth gem, so it's here now
  ##############################################################
  ##############################################################

  # => oAuth
  # => This is from https://github.com/omniauth/omniauth/wiki/Sinatra-Example
  get '/auth/:name/callback' do

    # => Auth object (data)
    # => Structure credentials: { expires_at: x, token: y, refresh_token: z}
    auth = request.env['omniauth.auth']

    # => Update
    # => This updates the user so that we're able to access the token/refresh token in future
    current_user.access_token         = auth['credentials']['token']
    current_user.refresh_token        = auth['credentials']['refresh_token']
    current_user.access_token_expires = Time.at(auth['credentials']['expires_at'])
    current_user.save

    # => Options
    # => Fill out the obligations of the company (the returns they have and have yet to fulfill)

    # => Action
    # => Redirect to homepage
    redirect "/", notice: "Authenticated, thank you"

  end #get

  ##############################################################
  ##############################################################

  # => oAuth Failure
  # => Apparently will send failure messages to this address
  get '/auth/failure' do
    redirect '/', notice: params[:message]
  end #get

  ##############################################################
  ##############################################################

  # => Revoke
  # => This is from https://github.com/omniauth/omniauth/wiki/Sinatra-Example
  delete '/auth/hmrc_vat/revoke' do

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

end ## app.rb

##########################################################
##########################################################
