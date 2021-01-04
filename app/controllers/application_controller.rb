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

  # => General
  # => https://stackoverflow.com/a/12681603/1143732
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  ##############################################################
  ##############################################################

  # => General
  # => Pulls pages (some are static and need to be shown outside of the authentication system)
  get '/', '/privacy', '/terms' do

    # Set ID
    # This is set if no :id is passed (IE the user is on the index page)
    params[:id] ||= :index

    # Response
    respond_to do |format|
      format.js   { haml params[:id].to_sym, layout: false }
      format.html {
        begin
          haml params[:id].to_sym
        rescue
          halt(404)
        end
      }
    end

  end

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

    # => Action
    # => Redirect to homepage
    redirect "/", notice: "Authenicated, thank you"

  end

  ##############################################################
  ##############################################################

  ## Private ##
  private

  # => Not Found
  # => Allows us to show error pages for the "Not Found" element
  def not_found
    redirect: "/", error: "Not Found"
  end

  ##############################################################
  ##############################################################

end ## app.rb

##########################################################
##########################################################
