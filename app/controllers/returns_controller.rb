############################################################
############################################################
##            ____       __                               ##
##           / __ \___  / /___  ___________  _____        ##
##          / /_/ / _ \/ __/ / / / ___/ __ \/ ___/        ##
##         / _, _/  __/ /_/ /_/ / /  / / / (__  )         ##
##        /_/ |_|\___/\__/\__,_/_/  /_/ /_/____/          ##
##                                                        ##
############################################################
############################################################
## Objects associated with users, which allows us to call
## the various pieces of data required to get the user submitted
############################################################
############################################################

# => Returns
# => Used to pull obligations, returns and liabilities from the HMRC endpoints
# => https://developer.service.hmrc.gov.uk/api-documentation/docs/api/service/vat-api
class ReturnsController < ApplicationController

  # => HMRC has 5 different endpoints (obligations, returns, payments, liabilities and return/{{ period }})
  # => We use this controller to populate our "returns" and also provide a means to create/store new ones
  # => -
  # => CRUD
  # => Allows us to ensure we have the most effective use of the tools (also using the API)

  ##############################################################
  ##############################################################

  # => Authorization
  # => Ensures we are able to only allow this if the user is logged in and has the appropriate credentials (vrn etc)
  before do
    redirect '/', error: "No Authorization" if (current_user.try(:vtr) && current_user.vtr.blank?) || !current_user.authenticated?
  end

  ################################
  ################################

  # => Obligations
  # => Gets a lit of VAT obligations (IE unsubmitted returns) and whether they have been fulfilled or not
  # => -
  # => This is different to the index returns list as that pulls from our database
  # => This is meant to repopulate the list of obligations a company may have
  get '/' do # => localhost/returns (get all)

    # => HMRC
    # => Sets the required data for the API
    # => https://developer.service.hmrc.gov.uk/api-documentation/docs/api/service/vat-api/1.0#_retrieve-vat-obligations_get_accordion
    hmrc = HMRC.new(current_user)

    # => Objects
    # => These are used to get data from the HMRC variable above
    response = hmrc.obligations

    # => Response
    # => This examines the response code and (if it's anything other than 200, redirect to the homepage and show an error)
    if response.code != 200

      # => Redirect
      # => This redirects to the homepage
      message = { error: response.parsed_response["message"] }

    else

      # => Obligations
      # => This used to be an upsert_all job but since the ActiveRecord implementation is sketchy at best, we needed to use the activerecord-import gem
      obligations = response.parsed_response["obligations"]

      # => Each
      # => Because upsert requires each hash contain the same keys, we need to cycle through them
      obligations.each do |obligation|

        # => Fulfilled
        # => This only fires if the obligation is considered "Fulfilled"
         if obligation["status"] == "F"

          # => Vars
          # => Populate a number of variables to use in the block
          vat_return = hmrc.returns(obligation["periodKey"])

          # => Return
          # => If the obligation is "fulfilled", get the individual element from the API
          obligation.merge(vat_return)

        end #fulfilled

        # => Update
        # => Update the system with the various obligations
        current_user.returns.upsert obligation.merge({ 'created_at' => DateTime.now, 'updated_at' => DateTime.now }), unique_by: :periodKey

      end

    end

    # => Action
    # => This checks for an error code and redirects to home if it is there
    redirect '/', message || { notice: "Updated" }

  end #get

  ################################
  ################################

end #class

############################################################
############################################################
