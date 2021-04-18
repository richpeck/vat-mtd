#####################################################################
#####################################################################
##     ______            __             __  ____                   ##
##    / ____/___  ____  / /____  ____  / /_/ __ \_________  ____   ##
##   / /   / __ \/ __ \/ __/ _ \/ __ \/ __/ / / / ___/ __ \/ __ \  ##
##  / /___/ /_/ / / / / /_/  __/ / / / /_/ /_/ / /  / /_/ / /_/ /  ##
##  \____/\____/_/ /_/\__/\___/_/ /_/\__/_____/_/   \____/ .___/   ##
##                                                      /_/        ##
#####################################################################
#####################################################################
## Used to populate several parts of the application, such as title ##
## Pulls from the database, meaning an admin is able to change its values if necessary ##
#####################################################################
#####################################################################

# => Content
# => Called by {{ content_for_layout }} in the views (basically the same as Shopify)
class ContentDrop < Liquid::Drop

  # => Constructor
  # => Builds the class and populates the values
  # => -
  # => Must be noted that the class we invoke is independent of the standard app flow, meaning we need to build it all from scratch
  def initialize(html)
    @content = html
    puts @context.inspect()
  end

end

#####################################################################
#####################################################################
