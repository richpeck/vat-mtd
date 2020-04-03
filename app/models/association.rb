####################################################################
####################################################################
##     ___                         _       __  _                  ##
##    /   |  ______________  _____(_)___ _/ /_(_)___  ____  _____ ##
##   / /| | / ___/ ___/ __ \/ ___/ / __ `/ __/ / __ \/ __ \/ ___/ ##
##  / ___ |(__  |__  ) /_/ / /__/ / /_/ / /_/ / /_/ / / / (__  )  ##
## /_/  |_/____/____/\____/\___/_/\__,_/\__/_/\____/_/ /_/____/   ##
##                                                                ##
####################################################################
####################################################################
## Gives us the ability to connect two or more objects together
## EG @shop.shapes.find(x).charms
####################################################################
####################################################################

## Association ##
## A link between two or more elements here allows us to manage the system in the front end
## id | user_id | associatiable_type | associatiable_id | associated_type | associated_id | created_at | updated_at ##
class Association < ActiveRecord::Base

  # => Allows us to match any type of object to another
  belongs_to :user
  belongs_to :associatiable, 	polymorphic: true
  belongs_to :associated, 	  polymorphic: true

end

############################################
############################################
