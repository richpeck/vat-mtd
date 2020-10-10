##########################################################
##########################################################
##                ____                                  ##
##               / __ \____  ____  __  __               ##
##              / /_/ / __ \/ __ \/ / / /               ##
##             / ____/ /_/ / / / / /_/ /                ##
##            /_/    \____/_/ /_/\__, /                 ##
##                              /____/                  ##
##                                                      ##
##########################################################
##########################################################

# => Pony
# => SMTP used to send email to account owner
# => https://github.com/benprew/pony#default-options
Pony.options = {
  via: :smtp,
  via_options: {
    address:  'smtp.sendgrid.net',
    port:     '587',
    domain:    DOMAIN,
    user_name: 'apikey',
    password:  ENV.fetch('SENDGRID', nil),
    authentication: :plain,
    enable_starttls_auto: true
  }
} #pony

##########################################################
##########################################################
