# frozen_string_literal: true

##############################################################
##############################################################
##                 __  ____  _______  ______                ##
##                / / / /  |/  / __ \/ ____/                ##
##               / /_/ / /|_/ / /_/ / /                     ##
##              / __  / /  / / _, _/ /___                   ##
##             /_/ /_/_/  /_/_/ |_|\____/                   ##
##                                                          ##
##############################################################
##############################################################
##    This is used to provide oAuth management for HMRC     ##
##############################################################
##############################################################

## Strategy ##
## Used to provide us with the ability to connect to HMRC's VAT endpoints ##
## https://github.com/hmrc/vat-api/issues/518 ##
## https://github.com/uzerpllp/uzerp/blob/master/lib/classes/standard/MTD.php ##
module OmniAuth
  module Strategies
    class HmrcVat < OmniAuth::Strategies::OAuth2

      ## Vars ##
      @@name     = "hmrc_vat"
      @@endpoint = ENV.fetch("HMRC_API_ENDPOINT", "https://test-api.service.hmrc.gov.uk")
      @@redirect = [Sinatra::Base.development? ? 'http://localhost:80' : "https://" + ENV.fetch("DOMAIN", "vat-mtd.herokuapp.com"), "auth"].join("/")

      # Give your strategy a name.
      option :name, @@name

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      option :client_options, { site: @@endpoint,  redirect_uri: [@@redirect, @@name, 'callback'].join("/") }

      # Scope
      # This allows us to define the scope through which the oAuth relationship will be conducted
      option :authorize_params, { scope: 'write:vat+read:vat' }

      # Token
      # Needed to ensure redirect_uri
      option :token_params, { redirect_uri: [@@redirect, @@name, 'callback'].join("/") }

      # You may specify that your strategy should use PKCE by setting
      # the pkce option to true: https://tools.ietf.org/html/rfc7636
      option :pkce, true

    end
  end
end
