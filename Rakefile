##########################################################
##########################################################
##                _____      _                          ##
##               | ___ \    | |                         ##
##               | |_/ /__ _| | _____                   ##
##               |    // _` | |/ / _ \                  ##
##               | |\ \ (_| |   <  __/                  ##
##               \_| \_\__,_|_|\_\___|                  ##
##                                                      ##
##########################################################
##########################################################
## This uses the sinatra-asset-pipeline gem to provide
## access to the Rails asset pipeline. The most important
## thing is to ensure you run any rake command after "bundle exec"
##########################################################
##########################################################

# => Libs
# => https://github.com/kalasjocke/sinatra-asset-pipeline#usage
require 'sinatra/activerecord/rake'   # => This works but ONLY if you call "bundle exec" - https://github.com/janko/sinatra-activerecord/issues/40#issuecomment-51647819
require 'sinatra/asset_pipeline/task' # => Sinatra Asset Pipeline

##########################################################
##########################################################

# => Load
# => This should have bundler load etc, but because we need to use the Rakefile, we need to load them with the other files ##
require_relative 'config/environment'

##########################################################
##########################################################

# => Rake Files
# => Requires "import" directive
# => https://blog.smartlogic.io/2009-05-26-including-external-rake-files-in-your-projects-rakefile-keep-your-rake-tasks-organized/
import 'lib/tasks/files.rake' # => files.rake (allows us to add/remove favicon on precompile)

##########################################################
##########################################################

# => Asset Pipeline
# => This allows us to integrate the Rails Assets Pipeline into Sinatra
Sinatra::AssetPipeline::Task.define! Environment

##########################################################
##########################################################
