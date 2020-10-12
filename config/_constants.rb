##########################################################
##########################################################
##      ____                 _              _           ##
##    /  __ \               | |            | |          ##
##    | /  \/ ___  _ __  ___| |_ __ _ _ __ | |_ ___     ##
##    | |    / _ \| '_ \/ __| __/ _` | '_ \| __/ __|    ##
##    | \__/\ (_) | | | \__ \ || (_| | | | | |_\__ \    ##
##     \____/\___/|_| |_|___/\__\__,_|_| |_|\__|___/    ##
##                                                      ##
##########################################################
##########################################################

## ENV ##
## Allows us to define before the App directory ##
DOMAIN              = ENV.fetch('DOMAIN', 'vat-mtd.herokuapp.com') ## used for CORS and other funtionality -- ENV var gives flexibility
DEBUG               = ENV.fetch("DEBUG", false) != false ## this needs to be evaluated this way because each ENV variable returns a string ##
SECRET              = ENV.fetch("SECRET", "62uao31c7d7j7dy6se9hs5auxyupmay") ## used to provide "shared secret" (for Rack Deflator)

HMRC_API_ENDPOINT   = ENV.fetch("HMRC_API_ENDPOINT",  "https://test-api.service.hmrc.gov.uk") # => production or sandbox URL
HMRC_AUTH_ENDPOINT  = ENV.fetch("HMRC_AUTH_ENDPOINT", "https://test-api.service.hmrc.gov.uk/oauth/authorize") # => https://developer.service.hmrc.gov.uk/api-documentation/docs/tutorials#user-restricted
HMRC_CLIENT_ID      = ENV.fetch("HMRC_CLIENT_ID", nil)
HMRC_CLIENT_SECRET  = ENV.fetch("HMRC_CLIENT_SECRET", nil)

##########################################################
##########################################################
