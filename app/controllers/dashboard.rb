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
class Dashboard < Config # => /config/settings.rb (wanted to include everything in Sinatra::Base, but looks like I have to subclass it for now)

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

end ## app.rb

##########################################################
##########################################################
