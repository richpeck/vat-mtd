############################################################
############################################################
##                  _   __          __                    ##
##                 / | / /___  ____/ /__                  ##
##                /  |/ / __ \/ __  / _ \                 ##
##               / /|  / /_/ / /_/ /  __/                 ##
##              /_/ |_/\____/\__,_/\___/                  ##
##                                                        ##
############################################################
############################################################
## Central data object in system (allows us to store data payload + appended data)
## Allows us to move pages around with content etc @node.contents
############################################################
############################################################

## Node ##
## This only stores "user" data (we have "profile" for extras)
## id | user_id | ref | password (encrypted) | created_at | updated_at ##
class Node < ActiveRecord::Base

  ################################
  ################################

  # => Users
  # => Because we need to scope each Page around a user, the following is necessary
  belongs_to :user, required: true, inverse_of: :nodes

  # => Associations
  # => A page can belong to a "database", allowing it to inherit a number of properties from it
  has_many :associations, as: :associated, dependent: :destroy
  has_many :properties, through: :associations, source: :associatiable, source_type: "Property"

  ################################
  ################################

  # => Acts as List
  # => Allows us to organize the objects as lists etc
  acts_as_list scope: :user

  # => Acts As Tree
  # => Allows us to define a tree type infrastructure for the nodes
  #acts_as_tree order: "title"

  ################################
  ################################

  # => Validations
  validates :val, exclusion: { in: %w(app class klass),  message: "%{value} is reserved.", scope: :ref }, uniqueness: { scope: :ref, message: "%{value} already present." }, if: -> { ref == "meta" } # => "meta" nodes

  ################################
  ################################

end

############################################################
############################################################
