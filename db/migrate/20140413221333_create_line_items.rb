##########################################################
##########################################################
##     _     _           _____ _                        ##
##    | |   (_)         |_   _| |                       ##
##    | |    _ _ __   ___ | | | |_ ___ _ __ ___  ___    ##
##    | |   | | '_ \ / _ \| | | __/ _ \ '_ ` _ \/ __|   ##
##    | |___| | | | |  __/| |_| ||  __/ | | | | \__ \   ##
##    \_____/_|_| |_|\___\___/ \__\___|_| |_| |_|___/   ##
##                                                      ##
##########################################################
##########################################################

## Line Items ##
## Allows us to populate line items per shop from Shopify ##
class CreateLineItems < ActiveRecord::Migration::Current

  ###########################################
  ###########################################

  # => Decs
  @@table = :line_items

  ###########################################
  ###########################################

  ## Up ##
  def up
    create_table @@table do |t|

      # => Shop
      # => Needs to belong to shop (otherwise anyone can see anything)
      t.references :shop

      # => Attributes
      # => These may be added to later (24/01/2020 - removed variant_id because it's stored in associations)
      t.integer :product_id,   limit: 8
      t.string  :vendor
      t.string  :title
      t.string  :sku
      t.text    :url
      t.text    :image
      t.decimal :price, precision: 10, scale: 2

      # => Timestamps
      t.timestamps

      # => Index
      # => Allows us to save only valid records
      t.index [:product_id, :shop_id], unique: true, name: 'product_id_shop_id_rpeck_unique_index'

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
