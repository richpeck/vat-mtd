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

DOMAIN              = ENV.fetch('DOMAIN', 'vat-mtd.herokuapp.com') ## used for CORS and other funtionality -- ENV var gives flexibility
DEBUG               = ENV.fetch("DEBUG", false) != false ## this needs to be evaluated this way because each ENV variable returns a string ##
SECRET              = ENV.fetch("SECRET", "62uao31c7d7j7dy6se9hs5auxyupmay") ## used to provide "shared secret" (for Rack Deflator)
ENVIRONMENT         = ENV.fetch("RACK_ENV", "development")

HMRC_API_ENDPOINT   = ENV.fetch("HMRC_API_ENDPOINT",  "https://test-api.service.hmrc.gov.uk") # => production or sandbox URL
HMRC_AUTH_ENDPOINT  = ENV.fetch("HMRC_AUTH_ENDPOINT", "https://test-api.service.hmrc.gov.uk/oauth/authorize") # => https://developer.service.hmrc.gov.uk/api-documentation/docs/tutorials#user-restricted
HMRC_CLIENT_ID      = ENV.fetch("HMRC_CLIENT_ID", nil)
HMRC_CLIENT_SECRET  = ENV.fetch("HMRC_CLIENT_SECRET", nil)

## Zeitwerk ##
## This should really have bundler stuff ##
## https://www.oreilly.com/library/view/sinatra-up-and/9781449306847/ch04.html ##
loader = Zeitwerk::Loader.new
%w(config lib app/controllers app/models).each do |d|
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
