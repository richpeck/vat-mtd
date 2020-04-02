############################################
############################################
##    ____ _                 _  __        ##
##  /  ___| |               (_)/ _|       ##
##  \ `--.| |__   ___  _ __  _| |_ _   _  ##
##   `--. \ '_ \ / _ \| '_ \| |  _| | | | ##
##  /\__/ / | | | (_) | |_) | | | | |_| | ##
##  \____/|_| |_|\___/| .__/|_|_|  \__, | ##
##                    | |           __/ | ##
##                    |_|          |___/  ##
##                                        ##
############################################
############################################
## This was added by the ShopifyApp gem
## It stores any new "stores" linked to the app via the Shopify oAuth process
############################################
############################################

## Shop ##
## id | shop_id | name | created_at | updated_at ##
class Shop < ActiveRecord::Base

  ####################################
  ####################################

  # => Shopify
  def self.secret
    @secret ||= ENV['SECRET']
  end

  attr_encrypted :token,
    key: secret,
    attribute: 'token_encrypted',
    mode: :single_iv_and_salt,
    algorithm: 'aes-256-cbc',
    insecure_mode: true

  validates_presence_of :name
  validates_presence_of :token, on: :create

  ####################################
  ####################################

  # => Associations
  has_many :orders, -> { extending Import }, dependent: :delete_all, inverse_of: :shop # => Remove orders
  has_many :customers,                       dependent: :delete_all                    # => Remove associated customers
  has_many :line_items,                      dependent: :delete_all                    # => Remove associated line items

  ####################################
  ####################################

end

############################################
############################################
