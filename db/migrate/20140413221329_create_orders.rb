############################################
############################################
##      _____         _                   ##
##     |  _  |       | |                  ##
##     | | | |_ __ __| | ___ _ __ ___     ##
##     | | | | '__/ _` |/ _ \ '__/ __|    ##
##     \ \_/ / | | (_| |  __/ |  \__ \    ##
##      \___/|_|  \__,_|\___|_|  |___/    ##
##                                        ##
############################################
############################################

## Orders ##
## Allows us to populate orders received from Shopify ##
class CreateOrders < ActiveRecord::Migration::Current

  ###########################################
  ###########################################

  # => Decs
  @@table = :orders

  ###########################################
  ###########################################

  ## Up ##
  def up
    create_table @@table do |t|

      # => Associations
      # => Allows us to store various associations for the system
      t.references :shop

      # => Attributes
      # => These may be added to later
      t.integer    :order_id,   limit: 8
      t.integer    :pwinty_id,  limit: 8
      t.integer    :number,     limit: 8
      t.text       :status             # => used to denote pwinty status
      t.decimal    :total_price,    precision: 10, scale: 2
      t.decimal    :subtotal_price, precision: 10, scale: 2
      t.decimal    :shipping_price, precision: 10, scale: 2

      # => Timestamps
      t.timestamps

      # => Index
      # => Allows us to save only valid records
      t.index :pwinty_id, unique: true, name: 'pwinty_unique_index'
      t.index [:shop_id, :order_id], unique: true, name: 'shop_and_order_rpeck_unique_index'

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
