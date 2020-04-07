###########################################
###########################################
##   _____                 __ _ _        ##
##  |  __ \               / _(_) |       ##
##  | |  \/ ___ _ __ ___ | |_ _| | ___   ##
##  | | __ / _ \ '_ ` _ \|  _| | |/ _ \  ##
##  | |_\ \  __/ | | | | | | | | |  __/  ##
##  \_____/\___|_| |_| |_|_| |_|_|\___|  ##
##                                       ##
###########################################
###########################################

# => Sources
source 'https://rubygems.org'

###########################################
###########################################

# => Ruby
# => https://github.com/cantino/huginn/blob/master/Gemfile#L4
ruby [RUBY_VERSION, '2.7.0'].max

# => Ruby 2.7.0
# => Required to get working with latest Ruby (TEMPORARY)
gem 'nokogiri', '~> 1.11.0.rc2'

###########################################
###########################################

# => Sinatra
# => Not big enough for Rails
gem 'sinatra', '~> 2.0', '>= 2.0.7',                                               require: ['sinatra/base', 'sinatra/namespace'] # => Not needed but allows us to call /namespace
gem 'sinatra-activerecord', '~> 2.0', '>= 2.0.14',                                 require: 'sinatra/activerecord'                # => Integrates ActiveRecord into Sinatra apps (I changed for AR6+)
gem 'sinatra-asset-pipeline', '~> 2.2', github: 'richpeck/sinatra-asset-pipeline', require: 'sinatra/asset_pipeline'              # => Asset Pipeline (for CSS/JS) (I changed lib/asset-pipeline/task.rb#14 to use ::Sinatra:Manifest)
gem 'sinatra-contrib', '~> 2.0', '>= 2.0.7',                                       require: 'sinatra/contrib'                     # => Allows us to add "contrib" library to Sinatra app (respond_with) -> http://sinatrarb.com/contrib/
gem 'sinatra-cors', '~> 1.1',                                                      require: 'sinatra/cors'                        # => Protect app via CORS
gem 'sinatra-redirect-with-flash', '~> 0.2.1',                                     require: 'sinatra/redirect_with_flash'         # => Redirect with Flash (allows use of redirect) -> https://github.com/vast/sinatra-redirect-with-flash
gem 'sinatra-support', '~> 1.2', '>= 1.2.2',                                       require: 'sinatra/support/i18nsupport'         # => Sinatra Support (helpers for Sinatra - https://github.com/sinefunc/sinatra-support) (used for LOCALES)

# => Database
# => Allows us to determine exactly which db we're using
# => To get the staging/production environments recognized by Heroku, set the "BUNDLE_WITHOUT" env var as explained here: https://devcenter.heroku.com/articles/bundler#specifying-gems-and-groups
gem 'sqlite3', group: :development
gem 'pg',      groups: [:staging, :production]

# => Server
# => Runs puma in development/staging/production
gem 'puma' # => web server

###########################################
###########################################

# => Environments
# => Allows us to load gems depending on the environment
group :development do
  gem 'irb'                            # => Console
  gem 'dotenv', require: 'dotenv/load' # => ENV vars (local) -- https://github.com/bkeepers/dotenv#sinatra-or-plain-ol-ruby
  gem 'foreman'                        # => Allows us to run the app in development/testing
  gem 'byebug'                         # => Debug tool for Ruby
end

###########################################
###########################################

####################
#     Backend      #
####################

# => General
gem "i18n", require: 'sinatra/support/i18nsupport'              # => Locales support (allows us to manage various responses from central location) - https://www.rubydoc.info/gems/sinatra-support/1.2.2/Sinatra/I18nSupport
gem 'rake'                                                      # => Allows for Rake usage
gem 'rack-flash3', require: 'rack-flash'                        # => Flash messages for Rack apps (required for "redirect_with_flash" -- #L44)
gem 'warden', '~> 1.2', '>= 1.2.8'                              # => Warden (authentication)
gem 'bcrypt', '~> 3.1', '>= 3.1.13'                             # => Password management (encrypts passwords if using SQLite3 -- if using Postgres, we have extensions)
gem 'htmlcompressor', '~> 0.4.0'                                # => HTMLCompressor (used to make the HTML have no spaces etc) // https://github.com/paolochiodi/htmlcompressor
gem 'httparty', '~> 0.18.0'                                     # => HTTParty - gives us the ability to interact with HMRC API without writing tons of code
gem 'rack-attack', '~> 6.2', '>= 6.2.2', require: 'rack/attack' # => Rack::Attack - allows us to block unwanted usage etc

# => Asset Management
gem 'uglifier', '~> 4.2'         # => Uglifier - Javascript minification (required to get minification working)
gem 'sass', '~> 3.7', '>= 3.7.4' # =>  SASS - converts SASS into CSS (required for minification)

# => Extra
# => Added to help us manage data structures in app
gem 'pony', '~> 1.13', '>= 1.13.1'            # => Email management for Ruby/Rails
gem 'addressable', '~> 2.7'                   # => Break down the various components of a domain
gem 'require_all', '~> 3.0'                   # => Require an entire directory and include in an app
gem 'padrino-helpers', '~> 0.14.4'            # => Sinatra framework which adds a number of support classes -- we needed it for "number_to_currency" (https://github.com/padrino/padrino-framework/blob/02feacb6afa9bce20c1fb360df4dfd4057899cfc/padrino-helpers/lib/padrino-helpers/number_helpers.rb)

# => ActiveRecord
# => Sinec we had multiple dependencies here, better to just add to our own category
gem 'activerecord',  '~> 6.0', '>= 6.0.2.2' # => Allows us to use AR 6.0.0.rc1+ as opposed to 5.2.x (will need to keep up to date)

###########################################
###########################################

####################
#     Frontend     #
####################

# => General
gem 'haml', '~> 5.1', '>= 5.1.2'      # => HAML
gem 'titleize', '~> 1.4', '>= 1.4.1'  # => Titleize (for order line items)
gem 'humanize', '~> 2.1', '>= 2.1.1'  # => Humanize (allows us to translate numbers to words)

# => Assets
# => Used to provide functionality to frontend (CSS/JS)
group :assets do

  ##################################
  ##################################

  # => RailsAssets
  # => This is not reliable, and may require refactoring (12/02/2020)
  # => It also needs to embody the gem inside the source block (new update)
  source 'https://rails-assets.org' do
    gem 'rails-assets-jquery'     # => JQuery    (https://github.com/jquery/jquery)
    gem 'rails-assets-parsleyjs'  # => ParselyJS (https://github.com/guillaumepotier/Parsley.js)
    gem 'rails-assets-bootstrap'  # => Bootstrap (https://github.com/twbs/bootstrap)
    gem 'rails-assets-jquery-ujs' # => JQueryUJS (https://github.com/rails/jquery-ujs)
  end

  ##################################
  ##################################

end
###########################################
###########################################
