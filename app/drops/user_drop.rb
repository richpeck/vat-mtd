###################################################
###################################################
##    __  __               ____                  ##
##   / / / /_______  _____/ __ \_________  ____  ##
##  / / / / ___/ _ \/ ___/ / / / ___/ __ \/ __ \ ##
## / /_/ (__  )  __/ /  / /_/ / /  / /_/ / /_/ / ##
## \____/____/\___/_/  /_____/_/   \____/ .___/  ##
##                                     /_/       ##
###################################################
###################################################
## Used to populate several parts of the application, such as title ##
## Pulls from the database, meaning an admin is able to change its values if necessary ##

# => User
# => Called by {{ user }} in the views
class UserDrop < Liquid::Drop

  # => Constructor
  # => Builds the class and populates the values
  # => -
  # => Must be noted that the class we invoke is independent of the standard app flow, meaning we need to build it all from scratch
  def initialize(user)
    @user = user
  end

  # => Email
  # => {{ user.email }}
  def email
    @user["email"]
  end

  # => VRN
  # => {{ user.vrn }}
  def vrn
    @user["vrn"]
  end

  # => Authenticated
  # => {{ user.authenticated? }}
  def authenticated?
    @user["authenticated?"]
  end

  # => Returns
  # => {{ user.returns }}
  def returns
    @user["returns"]
  end

end

###################################################
###################################################
