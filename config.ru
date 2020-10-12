##########################################################
##########################################################
##        ___      ___ ________  _________              ##
##       |\  \    /  /|\   __  \|\___   ___\            ##
##       \ \  \  /  / | \  \|\  \|___ \  \_|            ##
##        \ \  \/  / / \ \   __  \   \ \  \             ##
##         \ \    / /   \ \  \ \  \   \ \  \            ##
##          \ \__/ /     \ \__\ \__\   \ \__\           ##
##           \|__|/       \|__|\|__|    \|__|           ##
##                                                      ##
##########################################################
##########################################################
##                      VAT-MTD                         ##
## Allows us to define, manage and serve various routes ##
##########################################################
##########################################################
## Tool to provide VAT-MTD integration for anyone using ##
## spreadsheets to submit their VAT returns online.     ##
##########################################################
##########################################################

## Libraries ##
## RubyGems Required for Ubuntu ##
require 'rubygems' # => Necessary for Ubuntu

##########################################################
##########################################################

## Load ##
## This should have bundler load etc, but because we need to use the Rakefile, we need to load them with the other files ##
require_relative 'config/config'

##########################################################
##########################################################

## Sinatra ##
## Changed the following to include different app structure ##
## https://nickcharlton.net/posts/structuring-sinatra-applications.html ##
map('/returns')  { run Returns }
map('/settings') { run Settings }
map('/')         { run Dashboard }

##########################################################
##########################################################
