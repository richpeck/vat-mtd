############################################################
############################################################
##      ____                             __  _            ##
##     / __ \_________  ____  ___  _____/ /_(_)__  _____  ##
##    / /_/ / ___/ __ \/ __ \/ _ \/ ___/ __/ / _ \/ ___/  ##
##   / ____/ /  / /_/ / /_/ /  __/ /  / /_/ /  __(__  )   ##
##  /_/   /_/   \____/ .___/\___/_/   \__/_/\___/____/    ##
##                  /_/                                   ##
##                                                        ##
############################################################
############################################################
## Gives us the ability to create & manage "users"
## EG @page.properties (goes through database)
############################################################
############################################################

## Property ##
## id | user_id | type | name | created_at | updated_at ##
class Property < ActiveRecord::Base

  # => Associations
  # => Give us the ability to connect with other models
  belongs_to :user, required: true

  # => Enum
  # => This is used to denote the "type" of property
  # => For example, you may have "checklist", "datetime" etc
  # => The resaon for this (and not STI's is because we don't know how complicated the types will be)
  enum type: %W(checkbox text selectbox)

end

############################################
############################################
