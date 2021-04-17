############################################################
############################################################
##               _   __          __                       ##
##              / | / /___  ____/ /__  _____              ##
##             /  |/ / __ \/ __  / _ \/ ___/              ##
##            / /|  / /_/ / /_/ /  __(__  )               ##
##           /_/ |_/\____/\__,_/\___/____/                ##
##                                                        ##
############################################################
############################################################
## Gives us the ability to manage "settings" for user objects
## EG @user.settings.css_styles
##############################################################
##############################################################

# => Default (Attributes)
# => Reference for how to create "default" attributes in Rails 5+
# => https://stackoverflow.com/a/43484863/1143732

##############################################################
##############################################################

## Node  ##
## Because we want to keep the app simple, this stores all the required information (no profile model) ##
## id | type (for single table inheritance) |  user_id | name | value | created_at | updated_at ##
class Node < ActiveRecord::Base

  # => Associations
  # => Ensures we are able to keep records stored globally
  belongs_to :user, optional: true

  # => Validations
  # => Ensure the various elements are stored
  validates :name, :value, length: { minimum: 2,       message: "2 characters minimum" }
  validates :name, exclusion:    { in: %w(meta role),  message: "%{value} is reserved" }  # => http://stackoverflow.com/a/17668634/1143732
  validates :name, uniqueness:   { scope: :ref,        message: "%{value} cannot be duplicate" }

end

############################################
############################################
