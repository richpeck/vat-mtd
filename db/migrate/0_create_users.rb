############################################################
############################################################
##                __  __                                  ##
##               / / / /_______  __________               ##
##              / / / / ___/ _ \/ ___/ ___/               ##
##             / /_/ (__  )  __/ /  (__  )                ##
##             \____/____/\___/_/  /____/                 ##
##                                                        ##
############################################################
############################################################

## Users ##
## id | name | email | password_digest (encrypted) | vrn | last_signed_in_ip | last_signed_in_at | created_at | updated_at ##
class CreateUsers < ActiveRecord::Migration::Base # => lib/active_record/migration/base.rb

  ## Password ##
  ## Storing passwords requires encryption. Obviously, how this is done is dependent on the technology stack ##
  ## Whilst chkpass works on Postgres, I decided to use BCrypt across the board ##
  ## This is taken by virtue of a) BCrypt being more secure + b) it providing a central means to manage the software ##

  def up
    create_table table do |t|
      t.string  :email                                                           # => Email (login)
      t.string  :password_digest                                                 # => Password (login)
      t.string  :access_token                                                    # => oAuth access token (encrypted with the constant SECRET)
      t.string  :refresh_token                                                   # => oAuth refresh token (encrypted with the constant SECRET)
      t.string  :vrn, limit: 9                                                   # => VAT (9 character number) (vtr = VAT Tax Reference)
      t.send (adapter.to_sym == :SQLite ? :string : :inet), :last_signed_in_ip   # => last_signed_in_ip
      t.datetime :last_signed_in_at                                              # => last_signed_in_at
      t.datetime :access_token_expires                                           # => access_token_expires
      t.timestamps                                                               # => created_at, updated_at

      t.index :email, unique: true, name: 'email_unique' # => one email per user
    end
  end #up

end

####################################################################
####################################################################
