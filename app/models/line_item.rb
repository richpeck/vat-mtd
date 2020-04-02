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
## LineItems (saved from each order)
## Gives us ability to modularize each data element
############################################
############################################

## LineItem ##
## id | line_item_id | title | sku | price | created_at | updated_at ##
class LineItem < ActiveRecord::Base

  ######################################
  ######################################

  # => Associations
  belongs_to :shop # => This allows us to keep data consistent

  # => Orders
  # => Allowed to be attached to multiple orders
  has_many :associations, as: :associated, dependent: :destroy
  has_many :orders, through: :associations, source: :associatiable, source_type: "Order"

  # => Validations
  validates :line_item_id, :product_id, :title, presence: true

  # => Delegations
  # => Allows us to call methods for other objects
  delegate :name, to: :shop, prefix: true # => shop_name

  ######################################
  ######################################

  ## Properties ##
  ## Allows us to call "properties" on the line_item object ##

  # => Virtual attributes
  attr_accessor :properties, :order_number, :variant_id, :variant_title # => populated with activerecord association extension (concern/property.rb)
  # => properties populated via concerns/property.rb
  # => owner_id populated via concerns/property.rb (used to denote calling order)

  # => Properties
  # => Stored as JSON -> parse so we can read in app
  def properties

    # => Properties
    # => Only triggers if @properties is present
    return {} if @properties.blank?

    # => This is to rename the various keys
    # => If sending from Shopify (using hidden properties), you need to use _X as they key, but we just want to show it without the leading underscore
    items = JSON.parse(@properties)
    items.keys.map{ |k,v| items[k.split("_").join] = items.delete k }
    items["Dark"] = items.delete("Dark?") if items.has_key?("Dark?")

    # => Return
    OpenStruct.new(items).marshal_dump.deep_transform_keys!(&:downcase) # => order.line_items.first.properties[:colour]

  end #properties

  ######################################
  ######################################

  # => Image
  # => This is the image attached to the line_item (used to create image to send to Pwinty)
  # => We use the same technique as the JS in the front-end (masks and overlays)
  def image_to_send(send = :path)
    Image.new("#{order_number}-#{product_id}", **properties).send send # concerns/image.rb // Double-splat https://www.justinweiss.com/articles/fun-with-keyword-arguments/
  end

  ######################################
  ######################################

  # => Admin
  def admin_url
    "https://#{shop_name}/admin/products/#{product_id}"
  end

  ######################################
  ######################################

end

############################################
############################################
