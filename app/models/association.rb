##############################################################
##############################################################
##   ___                     _       _   _                  ##
##  / _ \                   (_)     | | (_)                 ##
## / /_\ \___ ___  ___   ___ _  __ _| |_ _  ___  _ __  ___  ##
## |  _  / __/ __|/ _ \ / __| |/ _` | __| |/ _ \| '_ \/ __| ##
## | | | \__ \__ \ (_) | (__| | (_| | |_| | (_) | | | \__ \ ##
## \_| |_/___/___/\___/ \___|_|\__,_|\__|_|\___/|_| |_|___/ ##
##                                                          ##
##############################################################
##############################################################
## Gives us the ability to connect two or more objects together
## EG @shop.shapes.find(x).charms
##############################################################
##############################################################

## Association ##
## A link between two or more elements here allows us to manage the system in the front end
## id | associatiable_type | associatiable_id | associated_type | associated_id | created_at | updated_at ##
class Association < ActiveRecord::Base

  # => Allows us to match any type of object to another
  belongs_to :associatiable, 	polymorphic: true
  belongs_to :associated, 	  polymorphic: true

end

############################################
############################################
