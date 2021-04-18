########################################################
########################################################
##     ________           __    ____                  ##
##    / ____/ /___ ______/ /_  / __ \_________  ____  ##
##   / /_  / / __ `/ ___/ __ \/ / / / ___/ __ \/ __ \ ##
##  / __/ / / /_/ (__  ) / / / /_/ / /  / /_/ / /_/ / ##
## /_/   /_/\__,_/____/_/ /_/_____/_/   \____/ .___/  ##
##                                          /_/       ##
########################################################
########################################################
## Used to populate several parts of the application, such as title ##
## Pulls from the database, meaning an admin is able to change its values if necessary ##

# => Flash
# => Called by {{ flash }} in the views
class FlashDrop < Liquid::Drop

  # => Constructor
  # => Builds the class and populates the values
  # => -
  # => Must be noted that the class we invoke is independent of the standard app flow, meaning we need to build it all from scratch
  def initialize(flash)
    @flash = flash
  end

  # => Message
  # => The underlying message of the flash object
  def message
    @flash.message
  end

end

###################################################
###################################################
