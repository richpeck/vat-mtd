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

# => [RailsAssets]
# => Requires source block to ensure gems pulled from this directly
#source 'https://rails-assets.org' do
#  gem 'rails-assets-jquery' # => JQuery
#  gem 'rails-assets-datatables' # => Datatables
#end

## RPECK 22/01/2020
## Rails-Assets went down and made the above unavailable - the response is either to use webpacker or /vendor
## We've used vendor/assets for the solution (static assets)

###########################################
###########################################

# => Ruby
# => https://github.com/cantino/huginn/blob/master/Gemfile#L4
ruby [RUBY_VERSION, '2.7.0'].max

###########################################
###########################################

# => Sinatra
# => Not big enough for Rails
gem 'sinatra', '~> 2.0', '>= 2.0.7',                                               require: ['sinatra/base', 'sinatra/namespace'] # => Not needed but allows us to call /namespace
gem 'shopify-sinatra-app', '~> 0.8.0',                                             require: 'sinatra/shopify-sinatra-app'         # => Allows us to create a shopify store with Sinatra (https://github.com/kevinhughes27/shopify-sinatra-app)
gem 'sinatra-activerecord', '~> 2.0', '>= 2.0.14',                                 require: 'sinatra/activerecord'                # => Integrates ActiveRecord into Sinatra apps (I changed for AR6+)
gem 'sinatra-asset-pipeline', '~> 2.2', github: 'richpeck/sinatra-asset-pipeline', require: 'sinatra/asset_pipeline'              # => Asset Pipeline (for CSS/JS) (I changed lib/asset-pipeline/task.rb#14 to use ::Sinatra:Manifest)
gem 'sinatra-contrib', '~> 2.0', '>= 2.0.7',                                       require: 'sinatra/contrib'                     # => Allows us to add "contrib" library to Sinatra app (respond_with) -> http://sinatrarb.com/contrib/
gem 'sinatra-cors', '~> 1.1',                                                      require: 'sinatra/cors'                        # => Protect app via CORS
gem 'sinatra-redirect-with-flash', '~> 0.2.1',                                     require: 'sinatra/redirect_with_flash'         # => Redirect with Flash (allows use of redirect) -> https://github.com/vast/sinatra-redirect-with-flash

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
# => Included by Sinatra-Shopify-App
gem 'pony', '~> 1.13', '>= 1.13.1', require: 'pony' # => Pony (send email via Ruby)
gem 'pwinty', '~> 3.0', '>= 3.0.3', github: 'richpeck/pwinty3-rb' # => Pwinty API Wrapper (error with original source) // 3.0.4 has a problem with packingSlipUrl
gem 'rake'                                          # => Allows for Rake usage
gem 'rack-flash3', require: 'rack-flash'            # => Flash messages for Rack apps (required for "redirect_with_flash" -- #L44)

# => Asset Management
gem 'uglifier', '~> 4.2'         # => Uglifier - Javascript minification (required to get minification working)
gem 'sass', '~> 3.7', '>= 3.7.4' # =>  SASS - converts SASS into CSS (required for minification)

# => Extra
# => Added to help us manage data structures in app
gem 'addressable', '~> 2.7'                   # => Break down the various components of a domain
gem 'activerecord', '~> 6.0', '>= 6.0.2.1'    # => Allows us to use AR 6.0.0.rc1+ as opposed to 5.2.x (will need to keep up to date)
gem 'require_all', '~> 3.0'                   # => Require an entire directory and include in an app
gem 'padrino-helpers', '~> 0.14.4'            # => Sinatra framework which adds a number of support classes -- we needed it for "number_to_currency" (https://github.com/padrino/padrino-framework/blob/02feacb6afa9bce20c1fb360df4dfd4057899cfc/padrino-helpers/lib/padrino-helpers/number_helpers.rb)

# => Images
# => Used to create/manage images + documents
gem 'mini_magick', '~> 4.10', '>= 4.10.1', require: 'mini_magick' # => ChunkyPNG - allows us to create/manage/edit PNG files (required for packageSlipUrl)
gem 'prawn', '~> 2.2', '>= 2.2.2',         require: 'prawn'      # => PrawnTable (required to get PDF's created -- not the most glamorous way to do it, but is robust)

###########################################
###########################################

####################
#     Frontend     #
####################

# => General
gem 'haml', '~> 5.1', '>= 5.1.2'      # => HAML
gem 'titleize', '~> 1.4', '>= 1.4.1'  # => Titleize (for order line items)
gem 'humanize', '~> 2.1', '>= 2.1.1'  # => Humanize (allows us to translate numbers to words)

###########################################
###########################################
