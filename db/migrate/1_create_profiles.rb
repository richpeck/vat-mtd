############################################################
############################################################
##             ____             _____ __                  ##
##            / __ \_________  / __(_) /__  _____         ##
##           / /_/ / ___/ __ \/ /_/ / / _ \/ ___/         ##
##          / ____/ /  / /_/ / __/ / /  __(__  )          ##
##         /_/   /_/   \____/_/ /_/_/\___/____/           ##
##                                                        ##
############################################################
############################################################

## Profiles ##
## id | user_id | role | name | created_at | updated_at ##
class CreateProfiles < ActiveRecord::Migration::Base # => lib/active_record/migration/base.rb
  def up
    create_table table, options do |t|
      t.references :user                                             # => user_id
      t.integer    :role, null: false, default: Profile.roles[:user] # => role
      t.string     :name                                             # => name
      t.timestamps                                                   # => created_at, updated_at
      t.index :user_id, unique: true, name: 'user_id_unique'         # => one profile per user
    end
  end
end

####################################################################
####################################################################
