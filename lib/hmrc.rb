##########################################################
##########################################################
##                __  ____  _______  ______             ##
##               / / / /  |/  / __ \/ ____/             ##
##              / /_/ / /|_/ / /_/ / /                  ##
##             / __  / /  / / _, _/ /___                ##
##            /_/ /_/_/  /_/_/ |_|\____/                ##
##                                                      ##
##########################################################
##########################################################
##                  HMRC API Wrapper                    ##
##  Uses HTTParty to create simple classes to interact  ##
##########################################################
##########################################################

## Class ##
## @hrmc = HMRC.new(vtr) ##
## https://developer.service.hmrc.gov.uk/api-documentation/docs/api/service/vat-api/1.0#_retrieve-vat-obligations_get_accordion ##
class HMRC

  ## HTTParty ##
  ## This allows us to wrap the HTTP/API requests in a wrapper, making it object oriented ##
  include HTTParty
  base_uri ENV.fetch("HMRC_API_ENDPOINT", "https://test-api.service.hmrc.gov.uk")

  ####################################
  ####################################

  ## Constructor ##
  ## Allows us to build out the class properly ##
  ## @hmrc = HMRC.new current_user.vtr
  def initialize current_user
    @vrn     = current_user.vrn
    @access  = current_user.access_token
    @query   = { "from": "2020-01-01", "to": "2021-01-01" }
    @headers = {

      # Authenication
      # Required to communicate with oAuth
      'Accept': 'application/vnd.hmrc.1.0+json',
      'Authorization': 'Bearer ' + @access,

      # Fraud headers
      # https://developer.service.hmrc.gov.uk/guides/fraud-prevention/connection-method/web-app-via-server/#gov-vendor-product-name
      'Gov-Client-Connection-Method': 'WEB_APP_VIA_SERVER',
      'Gov-Client-User-IDs': "vat-mtd=#{current_user.id}",
      'Gov-Client-Timezone': "UTC#{Time.now.strftime("%:z")}",
      'Gov-Vendor-Version': "vat-mtd=1.0.0"

    }
  end

  ####################################
  ####################################

  ## Obligations ##
  ## This pulls down the submitted returns and gives us a periodKey (which we use to pull individual returns) ##
  ## The aim is to store all returns in a single table ##
  def obligations
    self.class.get(url, { headers: @headers, query: @query })
  end

  ## Returns ##
  ## Allows us to get individual returns from the API
  def returns(periodKey)
    self.class.get(url("returns", periodKey), headers: @headers )
  end

  ## Liabilities ##
  ## Shows money owed to HMRC
  def returns(periodKey)
    self.class.get(url("liabilities"), headers: @headers, query: @query )
  end

  ####################################
  ####################################

  ## Private ##
  private

  # => URL
  # => Allows us to create class variable for HMRC endpoint etc
  # => https://test-api.service.hmrc.gov.uk/organisations/vat/{{ vrn }}/liabilities
  def url endpoint = "obligations", id = nil
    [ENV.fetch("HMRC_API_ENDPOINT", "https://test-api.service.hmrc.gov.uk"), "organisations/vat", @vrn, endpoint, id].join("/")
  end

  ####################################
  ####################################

end

##########################################################
##########################################################
