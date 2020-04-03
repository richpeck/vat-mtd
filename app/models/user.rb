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
## This only stores "user" data (we have "profile" for extras)
## id | email | password_digest (encrypted) | created_at | updated_at ##
class User < ActiveRecord::Base

  # => Profile
  # => Give us the ability to connect with other models
  has_one :profile, dependent: :destroy, inverse_of: :user
  before_create :build_profile, unless: :profile

  # => Associations
  # => has_many :pages and a bunch of other stuff
  has_many :nodes, -> { where(type: nil) }, inverse_of: :user
  has_many :options # => dependent on "meta" initializer

  # => Delegations
  # => @user.name (no prefix)
  delegate :name, :first_name, :role, to: :profile # => @user.name
  accepts_nested_attributes_for :profile

  # => Favorites
  # => Uses the "associations" model to provide us with the ability to "favourite" posts
  has_many :associations, as: :associated, dependent: :destroy
  #has_many :favorites, through: :associations, source: :associatiable, source_type: "Node" # => User 1 | Page 15

  # => Validations
  validates :email, uniqueness: true, presence: true

  # => Password
  # => This allows us to create a password + send it to email if the created user does not have a password (seed)
  attr_accessor :update_email # => Used to determine if a user needs to be emailed once they get registered
  after_create  Proc.new { |u| Pony.mail(to: self[:email], from: 'Notion Test <support@pcfixes.com>', subject: 'User Details', body: "Email: #{self[:email]}") }, unless: Proc.new { attribute_present?(:update_email) }

  # => Password (encryption)
  # => https://learn.co/lessons/sinatra-password-security#activerecord's-has_secure_password
  has_secure_password

  ################################
  ################################

  # => Public
  # => https://stackoverflow.com/questions/14568211/in-rails-how-can-i-delegate-to-a-class-method
  delegate :roles, to: :Profile # => only works for instances

  # => Roles
  # => Because we need to delegate at class level, need to do this separately
  class << self
    delegate :roles, to: :Profile
  end

  ################################
  ################################

end

############################################
############################################
