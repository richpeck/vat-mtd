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
## Allows us to save "orders" from the Shopify app
## Gives us ability to send said orders to Pwinty
############################################
############################################

## Order ##
## id | shop_id | customer_id | order_id | status_url | total_price | subtotal_price | created_at | updated_at ##
class Order < ActiveRecord::Base

  # => Associations
  # => Allows us to work with other objects in the system
  belongs_to :shop, inverse_of: :orders # => Added shop to make sure we have a means to get the orders for each shop

  # => Customer
  # => Has a customer record (each order needs a customer)
  has_one :customer, inverse_of: :order

  # => Line Items
  # => Products purchased from the store -- these need to be used by multiple orders
  has_many :associations, as: :associated, dependent: :destroy
  has_many :line_items, -> { extending Property }, through: :associations, source: :associatiable, source_type: "LineItem" # => https://stackoverflow.com/q/21401629/1143732

  # => Validations
  # => Store only valid data
  validates :order_id, presence: true, uniqueness: true

  #################################################
  #################################################

  # => Callbacks
  # => Allows us to manage the system
  after_create :pwinty, if: :shop_pwinty_auto
  after_update :notify_shop_owner, if: :shop_email_notifications

  #################################################
  #################################################

  # => Delegations
  # => Allows us to call methods for other objects
  delegate :name, :email, :pwinty_auto, :email_notifications, to: :shop, prefix: true # => shop_name
  delegate :name, :email, :phone, :address1, :address2, :city, :province, :zip, :country, to: :customer, prefix: true # => customer_name

  #################################################
  #################################################

    #############
    ## Private ##
    #############

    # => Dates
    # => Allows us to manage the various dates' formatting
    %i(created_at updated_at).each do |date|
      define_method date.to_s do |s = :short|
        self[date].to_formatted_s(s)
      end
    end

    # => Shipping Price
    # => Default to 0
    def shipping_price
      self[:shipping_price] || 0.00
    end

    # => Admin URL
    # => Helper to ensure we're able to access the admin url properly each time
    def admin_url
      "https://#{shop_name}/admin/orders/#{order_id}"
    end

    #################################################
    #################################################

    # => Invoice
    # => Returns PDF of packing slip (uses views/invoice.haml)
    def pdf
      Pdf.new(self, page_size: "A4") # => Important otherwise this is not set (http://prawnpdf.org/docs/0.11.1/Prawn/Document/PageGeometry.html)
    end

    #################################################
    #################################################

    # => Packing Slip
    # => Returns a PNG of the above PDF
    def png

      # => Initial
      # => Create Tempfile + populate with PDF
      @file = Tempfile.new("#{number}.pdf", binmode: true)
      pdf.render_file(@file)

      # => Vars
      # => Set so we can use after closing the temporary file
      @path     = @file.path
      @img      = MiniMagick::Image.open @path
      @filename = "#{File.dirname(@path)}/#{self.number}.png"

      # => Only works on Linux presently
      # => Uses mini-magick to convert the above PDF into a PNG (required by Pwinty)
      MiniMagick::Tool::Convert.new do |convert|
        convert << @path
        convert.background "white"
        convert.resize "2480x3508" #@img.dimensions.join("x") -> Prawn uses 72DPI, we need 300 for PNG (https://www.graphic-design-employment.com/a4-paper-dimensions.html)
        convert.flatten
        convert.density 150
        convert.quality 100
        convert << "png8:#{@filename}"
      end

      # => Deletes Tempfile
      # => All done by Ruby :)
      @file.unlink

      # => Send File
      # => This allows us to show the file to the user
      return @filename

    end

    #################################################
    #################################################

    # => Pwinty
    # => Creates/Updates Pwinty order information
    def pwinty orders: Pwinty::Order.list # => orders passed so we don't have to call the Pwinty API constantly

      # => Vars
      # => Check to see if Pwinty has our order before submitting a new one
      pwinty = orders.try(:any?) ? orders.select{ |o| o.merchantOrderId.to_s == self.try(:number).try(:to_s) } : nil

      # => Data
      # => This is used to build the object we send to Pwinty
      data = {
        merchantOrderId:          self.try(:number), # => optional
        recipientName:            customer_name,
        address1:                 customer_address1,
        address2:                 customer_address2,
        emal:                     customer_email,
        addressTownOrCity:        customer_city,
        stateOrCounty:            customer_province,
        postalOrZipCode:          customer_zip,
        countryCode:              customer_country,
        preferredShippingMethod:  "Budget"
      }

      # => Create/Update
      # => This is either created or updated
      order = pwinty.present? ? Pwinty::Order.find(pwinty.first.id) : Pwinty::Order.create(data)
      order.update data if pwinty.present? # => returns real object

      # => Images
      # => This allows us to get or create the images we want to send
      # => Only allows us to add one image at present (may have to refactor)
      # => https://github.com/tomharvey/pwinty3-rb#add-an-image-to-your-order
      if self.line_items.any?
        self.line_items.each do |line_item| # => line_items per order

          # => Vars
          # => Set Q variable (allows us to determine if valid or not)
          q = false

          # => Get Image SKU
          # => This is from the PWINTY_SKU constant located in config/constants.rb
          sku = line_item.variant_title.to_s.include?("Framed") && !line_item.variant_title.to_s.include?("Not Framed") ? PWINTY_SKU[:framed] : PWINTY_SKU[:normal] # => Framed or not (defaults to normal)
          sku = line_item.variant_title.to_s.include?("A4") ? sku[:A4] : sku[:A3] # => Size (defaults to A3)

          # => Images
          # => This is validation for the main order object
          # => The issue is that you can't change an image that's already uploaded. Thus, we need to ensure that the images we have sent are uploaded to Pwinty in the most effective way
          if images = order.try(:images)
            images.each do |image|
              q = (image.status != "Ok" || image.status != "NotYetDownloaded") ? false : true
            end
          end

          # => Add image if image has not been validated before
          # => This can be done before submitting the order
          if images.count <= 1 && q != true # => image.count used to ensure we're not adding tons of images
            order.add_image(
              sku: sku,
              url: URI::HTTPS.build( host: "pwinty-integration.herokuapp.com", path: "/" + line_item.image_to_send, query: {verify: 1}.to_query ).to_s,
              copies: 1,
            )
          end

        end
      end

      # => Order Management
      # => Allows us to update the order's transactions list
      self.update status: order.try(:submission_status).try(:generalErrors).try(:first) || order.try(:status), pwinty_id: order.try(:id)

      # => Action
      # => This should return notice or error, but for now, we'll just use notice
      return { notice: "##{number} Updated" }

    end

    #################################################
    #################################################

    # => Notify Shop Owner
    # => Used to share updates with shop owner
    def notify_shop_owner to: (ENVIRONMENT == "development" ? "johnclancy1997@gmail.com" : shop_email), from: "Fox-And-Oak.com <#{shop_email}>", subject: number, body:
      body ||= self.column_names.map.with_index{ |attribute, i| body[i] = "#{attribute.capitalize}: #{self.send(attribute)}" }.join("\n")
      Pony.mail(to: to, from: from, subject: subject, body: body)
    end

  #################################################
  #################################################

end

############################################
############################################
