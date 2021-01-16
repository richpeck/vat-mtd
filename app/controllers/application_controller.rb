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
  get '/', '/privacy', '/terms' do

    # Set ID
    # This is set if no :id is passed (IE the user is on the index page)
    params[:id] ||= :index

haml :index

  end

  ##############################################################
  ##############################################################

  # => oAuth
  # => This is from https://github.com/omniauth/omniauth/wiki/Sinatra-Example
  get '/auth/:name/callback' do

    # => Auth object (data)
    # => Structure credentials: { expires_at: x, token: y, refresh_token: z}
    auth = request.env['omniauth.auth']

    puts auth.inspect()

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
    redirect "/", notice: "Authenicated, thank you"

  end

  ##############################################################
  ##############################################################

end ## app.rb

##########################################################
##########################################################
