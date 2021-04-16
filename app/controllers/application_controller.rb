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
class ApplicationController < ::Autoload # => /config/settings.rb (wanted to include everything in Sinatra::Base, but looks like I have to subclass it for now)

  # => Helpers
  # => Allows us to call helpers as required
  # => https://stackoverflow.com/a/7642637/1143732
  helpers ApplicationHelper

  ##############################################################
  ##############################################################

  # => General
  # => Pulls pages (some are static and need to be shown outside of the authentication system)
  get '/', '/:id' do

    # => Auth
    # => Allows us to determine whether the page is authenticated or not
    pass if [settings.auth_login, settings.auth_logout, settings.auth_register, settings.auth_unauth].include?(request.path_info.tr('/', '')) # => auth routes

    # => Vars
    # => Required for certain views
    @path    = params[:id] || :index
    @columns = Return.attribute_names - %w(id user_id updated_at)

    # => Hook
    # => This allows us to manage the underlying user-level code that may be present in the above HAML
    # => For example, maybe we include a "sections" part in the above. The user can add a section with liquid code, which will then be rendered by the HAML and parsed by Liquid
    perform_action :pre_render, haml(@path.to_sym)

  end ## get

end ## app.rb

##########################################################
##########################################################
