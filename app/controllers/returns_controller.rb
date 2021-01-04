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

# => Class
# => Creates "Returns" namespace
# => Referenced in ./config.ru
class ReturnsController < ApplicationController

  ################################
  ################################

  # => Redirect
  # => Only works if the user has added the VTR to their account & authenticated with HMRC (not required for hello-world)
  before /(?!\/(obligations|returns))/ do
    redirect '/', error: "No Authentication" unless (current_user.try(:vtr) && !current_user.vtr.blank?) || !current_user.authenticated?
  end

  ################################
  ################################

  # => Hello World
  # => Allows us to test the HMRC API connectivity
  # => Open to everyone (in dev) for testing
  get '/hello_world' do # => returns/hello_world

    # => HMRC
    # => Starts the API
    @url     = [ENV.fetch("HMRC_API_ENDPOINT", "https://test-api.service.hmrc.gov.uk"), "/organisations/vat/", current_user.vrn, "/obligations"].join()
    @query   = {
      "from": "2020-01-01",
      "to":   "2021-01-01"
    }
    @headers = {
      'Accept': 'application/vnd.hmrc.1.0+json',
      'Authorization': 'Bearer ' + current_user.access_token
    }

    response = HTTParty.get(@url, headers: @headers, query: @query)
    puts response.body

    # => Response
    # => This checks for an error code and redirects to home if it is there
    #redirect '/', r.try("code") ? { error: r.dig("code") } : { notice: r.dig("message") }

  end #get

  ################################
  ################################

end #class

############################################################
############################################################
