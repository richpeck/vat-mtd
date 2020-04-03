module ActiveRecord
  module Concerns
    module Seeds

      ## This is used to provide base functionality during seeding
      #########################################
      #########################################

        # => first_or_initialize
        # => https://snippets.aktagon.com/snippets/620-rails-find-or-initialize-and-find-or-create-methods-are-deprecated
        def create model, attrs, vals=nil

          # => Model
          # => http://stackoverflow.com/a/32869926/1143732
          model = model.to_s.titleize.gsub(" ","::")

          # => Model exists
          unless (model.constantize rescue nil).nil?

            # => Setup
            payload = model.constantize.where(attrs).first_or_initialize

            # => Action
            payload.update vals || attrs

            # => Output
            if payload.valid?
              puts "#{payload.class.name} #{payload.new_record? ? 'Created' : 'Updated'} - #{payload.ref}" + (payload.has_attribute?(:val) ? " → #{payload.val}" : nil)
            else
              puts "#{payload.class.name} Error - #{payload.errors.full_messages}"
            end

          else
            puts "Model Not Initialized"
          end

        end

        ########################################
        ########################################

        # => Iterate over hash or array
        # => http://stackoverflow.com/a/16413593/1143732
        def iterate model, h, ref=nil
          return h unless h.is_a?(Hash) || h.is_a?(Array) # => Return if not hash

          # => Linebreak
          puts "\n"

          # => Proceed if hash/array
          h.each do |k,v|

            # If v is nil, an array is being iterated and the value is k.
            # If v is not nil, a hash is being iterated and the value is v.
            value = v || k

            # Ref
            # If exists, need to prepend ref_
            reference = v ? "#{ref}#{'_' if ref}#{k}" : ref

            # => Iterate or continue
            if value.is_a?(Hash) || value.is_a?(Array)
              iterate model, value, k
            else
              create model, { ref: reference, val: value }, { seed: true }
            end
          end

        end

      #########################################
      #########################################

    end
  end
end
