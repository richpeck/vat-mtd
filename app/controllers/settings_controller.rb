############################################################
############################################################
##          ____      _   _   _                           ##
##        /  ___|    | | | | (_)                          ##
##        \ `--.  ___| |_| |_ _ _ __   __ _ ___           ##
##         `--. \/ _ \ __| __| | '_ \ / _` / __|          ##
##        /\__/ /  __/ |_| |_| | | | | (_| \__ \          ##
##        \____/ \___|\__|\__|_|_| |_|\__, |___/          ##
##                                     __/ |              ##
##                                    |___/               ##
############################################################
############################################################
## Settings forms (for users). Allows us to store preferences
## and data for each user on the system.
############################################################
############################################################

# => Class
# => Creates "Settings" namespace
# => Referenced in ./config.ru
class SettingsController < ApplicationController

    ##########################
    ##########################

    # => Authenticate
    # => Send requests to HMRC
    get '/authenticate' do
      body "test"
    end

    ##########################
    ##########################

    # => Settings
    # => Get all the settings for the current logged in user
    get '/' do
      haml :index
    end #get

    ##########################
    ##########################

    # => Submit
    # => Gives the ability to update the user record
    post  '/' do

      # => User
      # => Update user object
      @user = current_user.update params[:user]

      # => Action
      # => Return to the main page with either error or notice flash message
      redirect '/', @user ? {notice: "Updated"} : {error: "Errors"}

    end #post

    ##########################
    ##########################

end #class

############################################################
############################################################
