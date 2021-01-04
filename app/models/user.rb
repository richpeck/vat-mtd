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
## id | email | password_digest (encrypted) | vrn | created_at | updated_at ##
class User < ActiveRecord::Base

  ################################
  ################################

  ####################
  ##  Associations  ##
  ####################

  # => Returns
  # => Gives us ability to view & manage the various VAT returns for a user
  has_many :returns, dependent: :destroy

  ################################
  ################################

  ###################
  ##    General    ##
  ###################

  # => Validations
  # => Ensures we're able to store the correct data
  validates :email, uniqueness: true, presence: true
  validates :vrn,   format: { with: /\A\d+\z/, message: "Integers only." }, length: { is: 9 }, allow_blank: true # => VAT numbers are 9 characters (GB xxx xxx xxx)

  # => Password
  # => This allows us to create a password + send it to email if the created user does not have a password (seed)
  attr_accessor :update_email # => Used to determine if a user needs to be emailed once they get registered
  after_create  Proc.new { |u| Pony.mail(to: self[:email], from: 'VAT-MTD <support@pcfixes.com>', subject: 'User Details', body: "Email: #{self[:email]}") }, unless: Proc.new { attribute_present?(:update_email) }

  # => Password (encryption)
  # => https://learn.co/lessons/sinatra-password-security#activerecord's-has_secure_password
  has_secure_password

  # => oAuth Token (encrypted)
  # => Uses the Ruby bcrypt "has_secure_password" command to create encrypted password
  # => https://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html#method-i-has_secure_password
  has_secure_password :access_token, validations: false
  has_secure_password :refresh_token, validations: false

  ################################
  ################################

  ###################
  ##    Private    ##
  ###################

  # => Authenticated?
  # => Allows us to see if HMRC is authenticated or not
  # => Tests for the presence of the access token
  def authenticated?
    access_token_expires.present?
  end

  ################################
  ################################

end

############################################
############################################
