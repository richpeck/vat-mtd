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
  include HTTParty
  base_uri HMRC_API_ENDPOINT

  ## Constructor ##
  ## Allows us to build out the class properly ##
  ## @hmrc = HMRC.new current_user.vtr
  def initialize(vtr)
    @options = { vtr: vtr }
  end

  ## Obligations ##
  ## This pulls down the submitted returns and gives us a periodKey (which we use to pull individual returns) ##
  ## The aim is to store all returns in a single table ##
  def obligations
    self.class.get("/organisations/vat/#{@options.vtr}/obligations")
  end

  def users
    self.class.get("/2.2/users", @options)
  end
end

##########################################################
##########################################################
