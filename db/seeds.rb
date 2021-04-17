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

# => Pages
# => Stores front-end content which is only available if users are not logged in
Page.upsert_all([
  { name: "terms",   value: "Terms" },
  { name: "privacy", value: "<h4>Privacy Policy</h4><p>This is designed to provide users with the ability to maintain their privacy</p>" }
], unique_by: [:name, :user_id])

##########################################
##########################################
