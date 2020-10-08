##############################################
##############################################
##           _____ _ _                      ##
##          |  ___(_) |                     ##
##          | |_   _| | ___  ___            ##
##          |  _| | | |/ _ \/ __|           ##
##          | |   | | |  __/\__ \           ##
##          \_|   |_|_|\___||___/           ##
##                                          ##
##############################################
##############################################

## Libs ##
require 'fileutils'

## This to add / remove files from the precompilation processs ##
## For now, it's aimed at the "favicon" and "sitemap" files    ##
## Others can be added as required!                            ##

##############################################
##############################################

## Declarations ##
root    = File.join(File.dirname(__FILE__), "..", "..", "..")
create  = [ { from: File.join(root, "app", "assets", "images", "favicon.ico"), to: File.join(root, "public") } ]
destroy = ["favicon.ico", "sitemap.xml.gz", "sitemap1.xml.gz", "sitemap2.xml.gz"]

##############################################
##############################################

## New ##
Rake::Task["assets:precompile"].enhance do

  ## Create ##
  ## Takes the "create" variable and moves files from one location to another ##
  ## http://blog.honeybadger.io/ruby-splat-array-manipulation-destructuring#using-an-array-to-pass-multiple-arguments ##
  create.each do |item|

    ## Definitions ##
    ## Define the variables to use ##
    asset       = *item[:from].to_s
    destination = *item[:to].to_s

    ## Action ##
    ## Check if file exists / is same as present ##
    #if File.exist?(asset.first) && (!File.exist?(destination.first) || File.mtime(asset.first) > File.mtime(destination.first))
      FileUtils.cp asset, destination, verbose: false, preserve: true
    #end

  end
end

##############################################
##############################################

## Destroy ##
Rake::Task["assets:clobber"].enhance do

  ## Destroy ##
  ## Takes "destroy" variable and removes files it contains ##
  destroy.each do |file|
    file = File.join(root, "public", file)
    FileUtils.rm file, verbose: true if File.exist? file
  end

end

##############################################
##############################################
