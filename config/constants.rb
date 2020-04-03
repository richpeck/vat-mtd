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
DOMAIN              = ENV.fetch('DOMAIN', 'fox-and-oak.myshopify.com') ## used for CORS and other funtionality -- ENV var gives flexibility
DEBUG               = ENV.fetch("DEBUG", false) != false ## this needs to be evaluated this way because each ENV variable returns a string ##
ENVIRONMENT         = ENV.fetch("RACK_ENV", "development")
HMRC_API_ENDPOINT   = ENV.fetch("HMRC_API_ENDPOINT", "https://test-api.service.hmrc.gov.uk") # => production or sandbox URL

##########################################################
##########################################################
