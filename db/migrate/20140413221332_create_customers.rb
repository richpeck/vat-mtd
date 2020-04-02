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

## Orders ##
## Allows us to populate orders received from Shopify ##
class CreateCustomers < ActiveRecord::Migration::Current

  ###########################################
  ###########################################

  # => Decs
  @@table = :customers

  ###########################################
  ###########################################

  ## Up ##
  def up
    create_table @@table do |t|

      # => Associations
      # => Allows us to consider which data to save
      t.references :shop
      t.references :order

      # => Attributes
      # => These may be added to later
      t.string     :email
      t.string     :name
      t.string     :phone # => should be int but may have +55 country code
      t.string     :address1
      t.string     :address2
      t.string     :city
      t.string     :province
      t.string     :zip
      t.string     :country

      # => Timestamps
      t.timestamps

      # => Index
      # => Allows us to save only valid records
      # => New update means we keep each customer unique to each order.
      # => Not the most efficient but ensures data integrity
      t.index [:order_id, :shop_id], unique: true, name: 'order_and_shop_rpeck_unique_index'

    end
  end

  ###########################################
  ###########################################

  ## Down ##
  def down
    drop_table @@table, if_exists: true
  end

  ###########################################
  ###########################################

end

############################################################
############################################################
