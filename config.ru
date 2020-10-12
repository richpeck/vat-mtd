##################################################
##################################################
##  _____              __ _                     ##
## /  __ \            / _(_)                    ##
## | /  \/ ___  _ __ | |_ _  __ _   _ __ _   _  ##
## | |    / _ \| '_ \|  _| |/ _` | | '__| | | | ##
## | \__/\ (_) | | | | | | | (_| |_| |  | |_| | ##
##  \____/\___/|_| |_|_| |_|\__, (_)_|   \__,_| ##
##                           __/ |              ##
##                          |___/               ##
##################################################
##################################################
##           Entrypoint for Sinatra             ##
##################################################
##################################################

## Libraries ##
## RubyGems Required for Ubuntu ##
require 'rubygems' # => Necessary for Ubuntu

##################################################
##################################################

## Load ##
## This should have bundler load etc, but because we need to use the Rakefile, we need to load them with the other files ##
require_relative 'config/config'

##################################################
##################################################

## Sinatra ##
## Changed the following to include different app structure ##
## https://nickcharlton.net/posts/structuring-sinatra-applications.html ##
map('/returns')  { run Returns }
map('/settings') { run Settings }
map('/')         { run Application }

##################################################
##################################################
