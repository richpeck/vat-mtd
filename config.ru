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

## RubyGems ##
## Required for Ubuntu ##
require 'rubygems' # => Necessary for Ubuntu

## Sinatra ##
require_relative 'app/app'
run App

##################################################
##################################################
