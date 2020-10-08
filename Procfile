# Release
# Uses bin/sh (separate commands with semi-colon)
if [ "$RACK_ENV" != "development" ]; then
  release: ./config/deploy/release.sh
fi

# Web
# Runs web server
# To change port, set the PORT environment variable 
web: bundle exec puma -C config/deploy/puma.rb
