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
## Gives us the ability to create & manage "users"
## EG @user.pages.x
##############################################################
##############################################################

# => Default (Attributes)
# => Reference for how to create "default" attributes in Rails 5+
# => https://stackoverflow.com/a/43484863/1143732

##############################################################
##############################################################

## User ##
## Because we want to keep the app simple, this stores all the required information (no profile model) ##
## id | name | email | password_digest (encrypted) | vtr | created_at | updated_at ##
class User < ActiveRecord::Base

  ################################
  ################################

  ####################
  ##  Associations  ##
  ####################

  # => Returns
  # => Gives us ability to view & manage the various VAT returns for a user
  has_many :returns

  ################################
  ################################

  # => Validations
  # => Ensures we're able to store the correct data
  validates :email, uniqueness: true, presence: true
  validates :vtr,   format: { with: /\A\d+\z/, message: "Integers only." }, length: { is: 9 }, allow_blank: true # => VAT numbers are 9 characters (GB xxx xxx xxx)

  # => Password
  # => This allows us to create a password + send it to email if the created user does not have a password (seed)
  attr_accessor :update_email # => Used to determine if a user needs to be emailed once they get registered
  after_create  Proc.new { |u| Pony.mail(to: self[:email], from: 'VAT-MTD <support@pcfixes.com>', subject: 'User Details', body: "Email: #{self[:email]}") }, unless: Proc.new { attribute_present?(:update_email) }

  # => Password (encryption)
  # => https://learn.co/lessons/sinatra-password-security#activerecord's-has_secure_password
  has_secure_password

  ################################
  ################################

end

############################################
############################################
