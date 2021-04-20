####################################################
####################################################
##      ___                ____                   ##
##     /   |  ____  ____  / __ \_________  ____   ##
##    / /| | / __ \/ __ \/ / / / ___/ __ \/ __ \  ##
##   / ___ |/ /_/ / /_/ / /_/ / /  / /_/ / /_/ /  ##
##  /_/  |_/ .___/ .___/_____/_/   \____/ .___/   ##
##        /_/   /_/                    /_/        ##
##                                                ##
####################################################
####################################################
## Used to populate several parts of the application, such as title ##
## Pulls from the database, meaning an admin is able to change its values if necessary ##

# => AppDrop
# => Called by {{ app.title }} in the views
class AppDrop < Liquid::Drop

  # => Constructor
  # => Builds the class and populates the values
  def initialize
    #@app = Setting.where(name: 'app')
  end

  # => Title
  # => The title of the application
  # => This is used in the <title> part of the app
  def title
    "Vat MTD"
  end

  def description
    "Test2"
  end

  def price
    "Test3"
  end

end
