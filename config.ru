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
require_relative 'config/_constants' # => Required because Zeitwerk does not recognize pure Ruby (only classes/namespaces)

##################################################
##################################################

# => Load
# => This replaces individual requires with bundled gems
# => https://stackoverflow.com/a/1712669/1143732
require 'bundler/setup'

# => Pulls in all Gems
# => Replaces the need for individual gems
Bundler.require :default, ENV["RACK_ENV"] if defined?(Bundler) # => ENVIRONMENT only used here, can do away with constant if necessary

##################################################
##################################################

## Zeitwerk ##
## This should really have bundler stuff ##
## https://www.oreilly.com/library/view/sinatra-up-and/9781449306847/ch04.html ##
loader = Zeitwerk::Loader.new
%w(app/controllers app/models lib config).each do |d|
  loader.push_dir(d)
end
loader.enable_reloading # you need to opt-in before setup
loader.setup

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
