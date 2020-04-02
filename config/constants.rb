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
SHARED_SECRET       = ENV.fetch("SECRET", false)
SENDGRID_API_KEY    = ENV.fetch("SENDGRID_API_KEY", nil)
SENDGRID_USERNAME   = ENV.fetch("SENDGRID_USERNAME", nil)
PWINTY_SKU          = {
                        framed: { A4: "FRA-CLA-HGE-MOUNT1-GLA-A4", A3: "FRA-CLA-HGE-MOUNT1-GLA-A3" },
                        normal: { A4: "GLOBAL-HGE-A4", A3: "GLOBAL-HGE-A3" }
                      }

##########################################################
##########################################################
