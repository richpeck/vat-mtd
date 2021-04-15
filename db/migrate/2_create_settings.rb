############################################################
############################################################
##          _____      __  __  _                          ##
##         / ___/___  / /_/ /_(_)___  ____ ______         ##
##         \__ \/ _ \/ __/ __/ / __ \/ __ `/ ___/         ##
##        ___/ /  __/ /_/ /_/ / / / / /_/ (__  )          ##
##       /____/\___/\__/\__/_/_/ /_/\__, /____/           ##
##                                 /____/                 ##
##                                                        ##
############################################################
############################################################

## Setting ##
## id | user_id | name | value | created_at | updated_at ##
class CreateSettings < ActiveRecord::Migration::Base # => lib/active_record/migration/base.rb

  ## Password ##
  ## Storing passwords requires encryption. Obviously, how this is done is dependent on the technology stack ##
  ## Whilst chkpass works on Postgres, I decided to use BCrypt across the board ##
  ## This is taken by virtue of a) BCrypt being more secure + b) it providing a central means to manage the software ##

  def up
    create_table table do |t|
      t.belongs_to :user, foreign_key: true                                      # => User
      t.string  :name                                                            # => Name
      t.string  :value                                                           # => Value
      t.timestamps                                                               # => created_at, updated_at

      t.index [:name, :user], unique: true, name: 'name_user_unique' # => one email per user
    end
  end #up

end

####################################################################
####################################################################
