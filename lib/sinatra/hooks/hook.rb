##########################################################
##########################################################
##                 __  __            __                 ##
##                / / / /___  ____  / /__               ##
##               / /_/ / __ \/ __ \/ //_/               ##
##              / __  / /_/ / /_/ / ,<                  ##
##             /_/ /_/\____/\____/_/|_|                 ##
##                                                      ##
##########################################################
##########################################################
##                     Hook Class                       ##
##########################################################
##########################################################

## Class ##
## @hook = Hook.new(action, name, function, priority) ##
## This works almost exactly the same as Wordpress to populate an array of hook classes, which can be fired at runtime
class Sinatra::Hooks::Hook

  ####################################
  ####################################

  ## Attributes ##
  ## These are accessed at runtime from the class object (@hook.action etc) ##
  attr_accessor :action, :name, :function, :priority

  ####################################
  ####################################

  ## Constructor ##
  ## Allows us to build out the class properly ##
  ## @hmrc = HMRC.new current_user.vtr
  def initialize action, name, function, priority
    @action   = action
    @name     = name
    @function = function
    @priority = priority
  end

  ####################################
  ####################################

end

##########################################################
##########################################################
