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
User.create_with(password: ENV.fetch('ADMIN_PASS')).find_or_create_by! email: ENV.fetch('ADMIN_EMAIL')  # => password omitted means the system will send the password via email

# => Pages
# => Stores front-end content which is only available if users are not logged in
Node.upsert_all([
  { type: "Page", name: "terms",   value: "Terms" },
  { type: "Page", name: "privacy", value: "<h4>Privacy Policy</h4><p>This is designed to provide users with the ability to maintain their privacy</p>" },
  { type: "Page", name: "index",   value: '
    <div class="authentication">
        <h4>🔒 Authentication</h4>
        <div class="container">
          <h5><u>VRN (VAT Registration Number)</u></h5>
          <h6>This is a 9 digit number provided by HMRC: -</h6>
          = form_for current_user, url("/settings"), data: { parsley: {validate: \'true\', trigger: \'keyup\', required: {message: "Required"}}} do |f|
            - if @user.try(:errors)
              - @user.errors.full_messages.each do |message|
                = message
            = f.text_field :vrn, placeholder: "VAT Number (VRN)", value: current_user.try(:vrn), data: { parsley: { type: "number", minlength: "9", maxlength: "9" }}
            = f.submit
        </div>

      {% comment %} Need to check if HMRC is connected! {% endcomment %}
      {% if user.authenticated? %}
        <h4>📝 Returns</h4>
        {% if user.returns.any? %}
          %table{ width: "100%" }
            %thead
              %tr
                - @columns.each do |column|
                  %td= Return.human_attribute_name(column)
            %tbody
              - current_user.returns.order(start: :desc).each do |r|
                %tr
                  - @columns.each do |column|
                    %td= r.send(column)
        {% else %}
          Test
        {% endif %}

      {% else %}}
        <p align="center">You must #{ link_to \'authenticate with HMRC\', url("/auth/hmrc_vat"), method: :post, style: "text-decoration: underline"} before you can see any data.</p>
      {% endif %}

    </div>'
  }
], unique_by: [:name, :user_id])

##########################################
##########################################
