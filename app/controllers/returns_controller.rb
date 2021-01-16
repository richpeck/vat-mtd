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
    query   = { "from": "2020-01-01", "to": "2021-01-01" }
    headers = { 'Accept': 'application/vnd.hmrc.1.0+json', 'Authorization': 'Bearer ' + current_user.access_token }

    # => Response
    # => This handles the request (response) from the HMRC endpoint
    response = HMRC.new current_user

    # => Returns (populate)
    # => This will input the returns ("obligations") into the database
    # => The data for said returns will not be visible until we pull each return from the web
    current_user.returns.upsert_all response.parsed_response["obligations"], unique_by: :periodKey

    # => Action
    # => This checks for an error code and redirects to home if it is there
    redirect '/', notice: "Updated"

  end #get

  ################################
  ################################

end #class

############################################################
############################################################
