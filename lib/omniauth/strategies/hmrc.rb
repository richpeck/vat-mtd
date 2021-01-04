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

## OmniAuth ##
## Provides strategy to help us authenticate with HMRC ##
require 'omniauth-oauth2'

## Strategy ##
## Used to provide us with the ability to connect to HMRC's VAT endpoints ##
## https://github.com/hmrc/vat-api/issues/518 ##
## https://github.com/uzerpllp/uzerp/blob/master/lib/classes/standard/MTD.php ##
module OmniAuth
  module Strategies
    class Hmrc < OmniAuth::Strategies::OAuth2
      # Give your strategy a name.
      option :name, "hmrc"

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      option :client_options, {:site => ENV.fetch("HMRC_API_ENDPOINT", "https://test-api.service.hmrc.gov.uk") }

      # You may specify that your strategy should use PKCE by setting
      # the pkce option to true: https://tools.ietf.org/html/rfc7636
      option :pkce, true

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid{ raw_info['id'] }

      info do
        {
          :name => raw_info['name'],
          :email => raw_info['email']
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/me').parsed
      end

    end
  end
end
