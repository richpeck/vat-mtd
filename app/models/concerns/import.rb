##########################################################
##########################################################
##         _____                           _            ##
##        |_   _|                         | |           ##
##          | | _ __ ___  _ __   ___  _ __| |_          ##
##          | || '_ ` _ \| '_ \ / _ \| '__| __|         ##
##         _| || | | | | | |_) | (_) | |  | |_          ##
##         \___/_| |_| |_| .__/ \___/|_|   \__|         ##
##                       | |                            ##
##                       |_|                            ##
##########################################################
##########################################################
## Allows us to call @shop.orders.import x
##########################################################
##########################################################

#app/models/concerns/import.rb
#https://stackoverflow.com/a/34331479/1143732
module Import

  # => Import
  # => This creates (and updates) orders relating to the shop
  # => It used to be stored in the /app.rb file, but it was too large, so extracted here
  def import data=nil, pwinty: false # => Passes data & says to use Pwinty or not

    # => Vars
    # => Accepts inbound data and translates into Order/Customer records (now with Pwinty)
    @shop   = proxy_association.owner
    @pwinty = pwinty.try(:present?) ? Pwinty::Order.list : nil
    data    = data || ShopifyAPI::Order.find(:all)
    orders  = nil # => used later need to keep here for scope

    ################################
    ################################

    # => Data
    # => Give indifferent access to hash (@object.method rather than @object[:method])
    # => This can either be a hash or object -- this is only necessary if a it's a webhook
    if data.is_a?(Hash)
      x = data.to_json # => convert to JSON so we can then Openstruct it
      x = JSON.parse(x, object_class: OpenStruct) # => https://coderwall.com/p/74rajw/convert-a-complex-nested-hash-to-an-object
      data = [x] # => needed to do this to ensure we are able to use map- probably a simpler way to do it but this works
    end

    ################################
    ################################

    # => Upsert_All
    # => Each data object needs to be accessible with methods
    # => Because the webhook only delivers a single payload as a hash, we need to convert it
    # => After this, we're able to then use exactly the same methodology (.map + upsert) to get the data put into the db
    obj = data.map do |data|

      # => Returned data
      # => Needs to return array of objects/hashes, so the upsert_all feature can do its work
      {
        order: {
          shop_id:        @shop.id, # => required for upsert
          order_id:       data.try(:id),
          number:         data.try(:order_number),
          total_price:    data.try(:total_price),
          subtotal_price: data.try(:subtotal_price),
          shipping_price: data.try(:shipping_lines).try(:first).try(:price),
          created_at:     data.try(:created_at),
          updated_at:     Time.now # => required for upsert
        },
        customer: {
          shop_id:      @shop.id, # => required for upsert -- for some reason, upsert only works on naked classes (not relations)
          name:         data.try(:shipping_address).try(:name),
          email:        data.try(:email),
          phone:        data.try(:phone),
          address1:     data.try(:shipping_address).try(:address1),
          address2:     data.try(:shipping_address).try(:address2),
          city:         data.try(:shipping_address).try(:city),
          province:     data.try(:shipping_address).try(:province_code),
          zip:          data.try(:shipping_address).try(:zip),
          country:      data.try(:shipping_address).try(:country_code),
          created_at:   Time.now, # => required for upsert
          updated_at:   Time.now  # => required for upsert
        },
        line_items: data.line_items.map do |item|
          {
            shop_id:       @shop.id,
            product_id:    item.try(:product_id),
            vendor:        item.try(:vendor),
            sku:           item.try(:sku),
            title:         item.try(:title),
            url:           item.try(:url),
            image:         item.try(:image),
            price:         item.try(:price),
            properties:    item.try(:properties),
            variant_id:    item.try(:variant_id),
            variant_title: item.try(:variant_title),
            created_at:    Time.now, # => required for upsert
            updated_at:    Time.now  # => required for upsert
          }.with_indifferent_access.freeze
        end
      }.with_indifferent_access.freeze #=> string + symbol calls

    end #map

    ################################
    ################################

    # => Build
    # => Allows us to perform upsert on each element of above hash array
    obj.first.keys.each do |e|

      # => Vars
      # => Set specific values here
      const = e.to_s.singularize.camelize.constantize # => Customer/Order/LineItem
      index = ActiveRecord::Base.connection.indexes(e.to_s.pluralize).select{ |x| x.name.include? "rpeck_unique_index" }.first.name.to_sym # => https://stackoverflow.com/a/1684809/1143732

      # => Items
      # => Used to denote the types of items received (defaults to obj.pluck(e))
      # => The problem is that some values need to change (customer[:order_id]/line_items)
      case e
        when "customer"
          orders = @shop.orders
          obj.map{ |x| x[:customer][:order_id] = orders.find_by!(number: x[:order][:number]).id }
      end

      # => Return
      # => This could be cleared up (we only do it like this so we don't change the underlying obj variable)
      # => https://apidock.com/ruby/Enumerable/flat_map
      x = obj.pluck(e)

      # => Line Items
      # => Allows us to push the most effective solutions
      if e == "line_items"
        x.flatten!(1).map.with_index{ |a,i| x[i] = a.except(:properties, :variant_id, :variant_title) }
        x.uniq!{ |e| e["product_id"] }
      end

      # => Update
      # => Upsert_all only where [{order: {}},{order: {}}]
      # => pluck: https://stackoverflow.com/a/51705274/1143732
      const.upsert_all x, unique_by: index

    end

    ################################
    ################################

    # => Properties
    # => Allows us to pick out the various line items
    obj.each do |o|

      # => Order
      # => Multiple line items for each order
      # => Use orders local var (already populated above)
      order = orders.find_by! number: o[:order][:number]

      # => Cycle
      # => Allows us to define the line_items
      o[:line_items].each do |item|

        # => Line Item
        # => Allows us to create new object for the line item
        line_item = @shop.line_items.find_by! product_id: item[:product_id]

        # => Properties
        # => This allows us to add new properties to the association
        # => Going to have to hack this a little, but should work
        if item.try(:[], :properties)
          properties = {}
          item[:properties].each{ |property| properties[property.name] = property.value }
        end

        # => Only add if line_item does not exist in association
        order.line_items << line_item unless order.line_item_ids.include? line_item.id

        # => Associations
        # => This loads the association directly (allowing us to add properties etc)
        association = order.associations.find_by(associatiable_id: line_item.id, associatiable_type: "LineItem")

        if association
          association.assign_attributes properties: properties.to_json if properties.present?
          association.assign_attributes variant_id: item.try(:[], :variant_id), variant_title: item.try(:[], :variant_title) if item.try(:[], :variant_id) || item.try(:[], :variant_title)
          association.save if association.changed?
        end

        ##############################
        ##############################

        # => Pwinty
        # => Because upsert_all doesn't trigger ActiveRecord models, we need to call the pwinty method manually
        # => This may need to be refactored but should be okay for now
        order.pwinty orders: @pwinty if @shop.pwinty_auto?

        # => Email
        # => Because emails are not loaded, just have to call them (like Pwinty)
        order.notify_shop_owner if @shop.email_notifications?

        ##############################
        ##############################

      end #each

    end #each

    # => Return number of updated objects
    # => No point beating around bush
    return obj

    ################################
    ################################

  end #import

  #########################################
  #########################################


end
