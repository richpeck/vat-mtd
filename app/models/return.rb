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
## Gives us the ability to create & manage "returns"
## EG @user.returns
##############################################################
##############################################################

## Return ##
## Gives us the ability to store the data for each return ##
## id | periodKey | start_date | end_date | due_date | status (O // open or F // fulfilled) | vatDueSales | vatDueAcquisitions | totalVatDue | vatReclaimedCurrPeriod | netVatDue | totalValueSalesExVAT | totalValuePurchasesExVAT | totalValueGoodsSuppliedExVAT | totalAcquisitionsExVAT | created_at | updated_at ##
class Return < ActiveRecord::Base

  ################################
  ################################

  ####################
  ##  Associations  ##
  ####################

  # => User
  # => Belongs to a user (important)
  belongs_to :user, required: true

  ################################
  ################################

  # => Validations
  # => Ensures we're able to store the correct data
  validates :user_id, presence: true
  validates :periodKey, uniqueness: true, presence: true
  validates :status, inclusion: { in: ["O", "F"] }
  validates :totalValueSalesExVAT, :totalValuePurchasesExVAT, :totalValueGoodsSuppliedExVAT, :totalAcquisitionsExVAT, numericality: { in: -9999999999999..9999999999999, only_integer: true }

  ################################
  ################################

end

############################################
############################################
