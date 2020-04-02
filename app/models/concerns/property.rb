##########################################################
##########################################################
##       _____                          _               ##
##      | ___ \                        | |              ##
##      | |_/ / __ ___  _ __   ___ _ __| |_ _   _       ##
##      |  __/ '__/ _ \| '_ \ / _ \ '__| __| | | |      ##
##      | |  | | | (_) | |_) |  __/ |  | |_| |_| |      ##
##      \_|  |_|  \___/| .__/ \___|_|   \__|\__, |      ##
##                     | |                   __/ |      ##
##                     |_|                  |___/       ##
##########################################################
##########################################################
## Extends LineItem association, allowing us to access the "properties" attribute of the association table
##########################################################
##########################################################

#app/models/concerns/property.rb
#https://stackoverflow.com/a/34331479/1143732
module Property

    # => Load
    # => Triggered whenever module is invoked (allows us to populate response data)
    # => #<Method: ActiveRecord::Relation#load(&block) c:/Dev/Apps/pwinty-integration/.bundle/ruby/2.7.0/gems/activerecord-6.0.2.1/lib/active_record/relation.rb:614>
    def load(&block)

      # => This is called from the following reference - if you want to dig deeper, you can use method(:exec_queries).source_location
      # => c:/Dev/Apps/pwinty-integration/.bundle/ruby/2.7.0/gems/activerecord-6.0.2.1/lib/active_record/association_relation.rb:42
      unless loaded?
        exec_queries do |record|

          # => Items
          # => Allows us to manage the various pieces of data required
          added = {} # => this is for the image_to_send method (line_item.rb) -- if properties were not present, this would be omitted too
          added[:order_number] = proxy_association.owner.number
          added[:properties] = items[record.id][:properties] if items[record.id].present?

          # Variant
          # => This is used to determine if the
          if items[record.id][:variant][:title].present?
            added[:variant_id] = items[record.id][:variant][:id]
            added[:variant_title] = items[record.id][:variant][:title] # => added to give us the ability to manage variants
          end

          # => Add above attributes to record
          # => This may seem hacky, but should give us the functionality we require
          record.assign_attributes added

        end #execqueries
      end #unless

    end #load

   private

   # => Source Reflection
   # => This is the association_name for the source (in our case "associatable")
   def reflection_name
     proxy_association.source_reflection.name
   end

   # => Foreign Key
   # => Used to identify the foreign key of the object
   def through_source_key
      proxy_association.reflection.source_reflection.foreign_key
   end

   # => Primary Key
   # => Used to identify the primary key of the through object
   def through_primary_key
      proxy_association.reflection.through_reflection.active_record_primary_key
   end

   # => Through Name
   # => In our case @order.associations
   def through_name
     proxy_association.reflection.through_reflection.name
   end

   # => Collection
   # => This is the array of objects created by AR
   # => In our case, @order.associations
   def through_collection
      proxy_association.owner.send through_name
   end

   # => Items
   # => Allows us to pluck the required value from the join collection
   # => In other words, @order.associations.pluck(:properties)
   def items
     through_collection.pluck(through_source_key, :properties, :variant_id, :variant_title).map{ |id, properties, variant_id, variant_title| { id => { properties: properties, variant: { id: variant_id, title: variant_title } }}}.inject(:merge) # => pluck builds array, which we don't need (may need to change this later)
   end

end
