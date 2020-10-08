if [ "$RACK_ENV" != "development" ]; then
  # Release
  # Uses bin/sh (separate commands with semi-colon)
  release: ./config/deploy/release.sh
fi

# Web
# Runs web server
web: bundle exec puma -C config/deploy/puma.rb
