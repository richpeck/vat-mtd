############################################################
############################################################
##               _   __          __                       ##
##              / | / /___  ____/ /__  _____              ##
##             /  |/ / __ \/ __  / _ \/ ___/              ##
##            / /|  / /_/ / /_/ /  __(__  )               ##
##           /_/ |_/\____/\__,_/\___/____/                ##
##                                                        ##
############################################################
############################################################

## Nodes  ##
## id | user_id | name | value | created_at | updated_at ##
class CreateNodes < ActiveRecord::Migration::Base # => lib/active_record/migration/base.rb

  ## Password ##
  ## Storing passwords requires encryption. Obviously, how this is done is dependent on the technology stack ##
  ## Whilst chkpass works on Postgres, I decided to use BCrypt across the board ##
  ## This is taken by virtue of a) BCrypt being more secure + b) it providing a central means to manage the software ##

  def up
    create_table table do |t|
      t.belongs_to  :user, foreign_key: true                          # => User
      t.string      :type                                             # => Type (Single Table Inheritance)
      t.string      :name                                             # => Name
      t.text        :value                                            # => Value
      t.datetime    :created_at, default: -> { "CURRENT_TIMESTAMP" }  # => Created At (required to provide default)
      t.datetime    :updated_at, default: -> { "CURRENT_TIMESTAMP" }  # => Updated At (required to provide default)

      t.index [:name, :user_id], unique: true, name: 'name_user_unique' # => one email per user
    end
  end #up

end

####################################################################
####################################################################
