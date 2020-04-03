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
## Gives us the ability to create & manage user profiles
## EG @user.name
##############################################################
##############################################################

## Profile ##
## Allows us to attach superflous data to user accounts (avatar etc)
## id | email | password (encrypted) | created_at | updated_at ##
class Profile < ActiveRecord::Base

  #############################
  #############################

  # => Associations
  # => Give us the ability to connect with other models
  belongs_to :user, required: true, inverse_of: :profile

  # => Validations
  # => Ensure that a name is minimum of 2 characters
  validates :name, length: { minimum: 2 }, allow_blank: true # => http://stackoverflow.com/a/22323406/1143732

  # => Role
  attribute :locale, :string, default: 'en'

  ################################
  ################################

  # => Roles
  # => Simple means to define which roles we're using
  enum role: [:super_admin, :admin, :user]

  #############################
  #############################

  private

  # => Uploads
  # => Allows us to determine the format of the upload
  def format
    return unless avatar.attached?
    return if avatar.blob.content_type.start_with? 'image/'
    avatar.purge
    errors.add(:avatar, 'needs to be an image')
  end

end

############################################
############################################
