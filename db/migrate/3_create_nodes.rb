############################################################
############################################################
##                _   __          __                      ##
##               / | / /___  ____/ /__  _____             ##
##              /  |/ / __ \/ __  / _ \/ ___/             ##
##             / /|  / /_/ / /_/ /  __(__  )              ##
##            /_/ |_/\____/\__,_/\___/____/               ##
##                                                        ##
############################################################
############################################################
## Cental data object
############################################################
############################################################

## Nodes ##
## id | user_id | ref | value | created_at | updated_at ##
class CreateNodes < ActiveRecord::Migration::Base # => lib/active_record/migration/base.rb
  def up
    create_table table, options do |t| # => users stored through "associations"
      t.references  :user, default: 0 # => 0 should be super admin
      t.string		  :type
      t.string      :slug
      t.integer     :parent_id # => acts_as_tree (only works with Rails)
      t.integer     :position  # => acts_as_list
      t.string 		  :ref
      t.text		    :val, length: 4294967295
      t.timestamps  null: false
    end
  end
end

####################################################################
####################################################################
