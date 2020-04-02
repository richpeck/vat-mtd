##########################################################
##########################################################
##   _____           _                                  ##
##  /  __ \         | |                                 ##
##  | /  \/_   _ ___| |_ ___  _ __ ___   ___ _ __ ___   ##
##  | |   | | | / __| __/ _ \| '_ ` _ \ / _ \ '__/ __|  ##
##  | \__/\ |_| \__ \ || (_) | | | | | |  __/ |  \__ \  ##
##   \____/\__,_|___/\__\___/|_| |_| |_|\___|_|  |___/  ##
##                                                      ##
##########################################################
##########################################################
## Saves customer object for use with orders
## Better to do it this way (separate data) - pulled from shipping address
##########################################################
##########################################################

## Customer ##
## id | shop_id | name | email | phone | address1 | address2 | city | province | zip | country | created_at | updated_at ##
class Customer < ActiveRecord::Base

  ####################################
  ####################################

    # => Shop
    # => Allows us to delegate from the main shop object
    belongs_to :shop
    belongs_to :order, inverse_of: :customer # => to ensure wehave

    # => Validations
    # => Store only valid data
    validates :order, :shop, presence: true

  ####################################
  ####################################

    # => Name
    # => Allows us to replace "name" with email
    def name
      self[:name] || self[:email]
    end

  ####################################
  ####################################

end

##########################################################
##########################################################
