########################################
########################################
##     _____                          ##
##    | ___ \                         ##
##    | |_/ /   _ _ __ ___   __ _     ##
##    |  __/ | | | '_ ` _ \ / _` |    ##
##    | |  | |_| | | | | | | (_| |    ##
##    \_|   \__,_|_| |_| |_|\__,_|    ##
##                                    ##
########################################
########################################

# => Used to get Puma running the application
# => You can see how to get it set up here: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#config

########################################
########################################

threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV.fetch("PORT", 80)
environment ENV.fetch("RACK_ENV", "development")

# Plugins
plugin :tmp_restart

########################################
########################################
