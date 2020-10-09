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

# => Configuration Options
# => This should be loaded by bundler, but we need to do it here for now
# => Since 10/2020, added a base "settings.rb" file which stores all the settings for Sinatra
%w(constants).each do |file|
  require_relative "../../config/#{file}"
end

##########################################################
##########################################################

# => Load
# => This replaces individual requires with bundled gems
# => https://stackoverflow.com/a/1712669/1143732
require 'bundler/setup'

# => Pulls in all Gems
# => Replaces the need for individual gems
Bundler.require :default, ENV.fetch("RACK_ENV", "development") if defined?(Bundler) # => ENVIRONMENT only used here, can do away with constant if necessary

##########################################################
##########################################################

# => Models
# => This allows us to load all the models (which are not loaded by default)
require_all 'app', 'lib'

  require_relative "../../config/settings"

##########################################################
##########################################################

## Sinatra ##
## Based on - https://github.com/kevinhughes27/shopify-sinatra-app ##
class App < Sinatra::Base

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
  # => Pulls pages (allows to show modals) - needs to be here to allow other routes to be called first
  get '/' do

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
