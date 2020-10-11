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

# => App
# => Loads environment etc
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

##########################################################
##########################################################

# => Rake Files
# => Requires "import" directive
# => https://blog.smartlogic.io/2009-05-26-including-external-rake-files-in-your-projects-rakefile-keep-your-rake-tasks-organized/
import 'lib/tasks/files.rake' # => files.rake (allows us to add/remove favicon on precompile)

##########################################################
##########################################################

Sinatra::AssetPipeline::Task.define! App # => Sinatra Asset Pipeline

##########################################################
##########################################################
