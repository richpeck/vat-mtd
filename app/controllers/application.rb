##########################################################
##########################################################
##        ___      ___ ________  _________              ##
##       |\  \    /  /|\   __  \|\___   ___\            ##
##       \ \  \  /  / | \  \|\  \|___ \  \_|            ##
##        \ \  \/  / / \ \   __  \   \ \  \             ##
##         \ \    / /   \ \  \ \  \   \ \  \            ##
##          \ \__/ /     \ \__\ \__\   \ \__\           ##
##           \|__|/       \|__|\|__|    \|__|           ##
##                                                      ##
##########################################################
##########################################################
##                      VAT-MTD                         ##
## Allows us to define, manage and serve various routes ##
##########################################################
##########################################################
## Tool to provide VAT-MTD integration for anyone using ##
## spreadsheets to submit their VAT returns online.     ##
##########################################################
##########################################################

## Sinatra ##
## Based on - https://github.com/kevinhughes27/shopify-sinatra-app ##
class Application < Config # => /config/settings.rb (wanted to include everything in Sinatra::Base, but looks like I have to subclass it for now)

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
