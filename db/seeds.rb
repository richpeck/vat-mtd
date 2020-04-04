##########################################
##########################################
##       _____               __         ##
##      / ___/___  ___  ____/ /____     ##
##      \__ \/ _ \/ _ \/ __  / ___/     ##
##     ___/ /  __/  __/ /_/ (__  )      ##
##    /____/\___/\___/\__,_/____/       ##
##                                      ##
##########################################
##########################################

# => SuperAdmin
# => User ID 0 is always superadmin, and we want to create them without any issues
@user = User.create_with(password: ENV.fetch('ADMIN_PASS')).find_or_create_by! email: ENV.fetch('ADMIN_EMAIL')  # => password omitted means the system will send the password via email

##########################################
##########################################
