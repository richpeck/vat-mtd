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
class CreateReturns < ActiveRecord::Migration::Base # => lib/active_record/migration/base.rb

  def up
    create_table table, options do |t|

      ########################
      ##       General      ##
      ########################

      # => User (required)
      # => Has to belong to a user (required for scoping)
      t.references :user, null: false

      # => periodKey (required)
      # => The ID code for the period that this obligation belongs to. The format is a string of four alphanumeric characters. Occasionally the format includes the # symbol.
      t.string :periodKey, null: false # => required for each record

      ########################
      ##     Obligations    ##
      ########################

      ## Pulls down returns for vtr within system
      ## https://developer.service.hmrc.gov.uk/api-documentation/docs/api/service/vat-api/1.0#_retrieve-vat-obligations_get_accordion

      # => start_date
      # => Date in the format YYYY-MM-DD
      t.date :start

      # => end_date
      # => Date in the format YYYY-MM-DD
      t.date :end

      # => due_date
      # => Date in the format YYYY-MM-DD
      t.date :due

      # => status
      # => Which obligation statuses to return (O = Open, F = Fulfilled)
      t.string :status, length: 1

      ########################
      ##       Returns      ##
      ########################

      ## Populates "return" data for each user
      ## Requires periodKey from obligations (above)
      ## https://developer.service.hmrc.gov.uk/api-documentation/docs/api/service/vat-api/1.0#_view-vat-return_get_accordion

      # => vatDueSales (Box 1)
      # => VAT due on sales and other outputs. This corresponds to box 1 on the VAT Return form. The value must be between -9999999999999.99 and 9999999999999.99.
      t.decimal :vatDueSales, precision: 13, scale: 2

      # => vatDueAcquisitions (Box 2)
      # => VAT due on acquisitions from other EC Member States. This corresponds to box 2 on the VAT Return form. The value must be between -9999999999999.99 and 9999999999999.99.
      t.decimal :vatDueAcquisitions, precision: 13, scale: 2

      # => totalVatDue (Box 3)
      # => Total VAT due (the sum of vatDueSales and vatDueAcquisitions). This corresponds to box 3 on the VAT Return form. The value must be between -9999999999999.99 and 9999999999999.99.
      t.decimal :vatDueDue, precision: 13, scale: 2

      # => vatReclaimedCurrPeriod (Box 4)
      # => VAT reclaimed on purchases and other inputs (including acquisitions from the EC). This corresponds to box 4 on the VAT Return form. The value must be between -9999999999999.99 and 9999999999999.99.
      t.decimal :vatReclaimedCurrPeriod, precision: 13, scale: 2

      # => netVatDue (Box 5)
      # => The difference between totalVatDue and vatReclaimedCurrPeriod. This corresponds to box 5 on the VAT Return form. The value must be between 0.00 and 99999999999.99.
      t.decimal :netVatDue, precision: 11, scale: 2

      # => totalValueSalesExVAT (Box 6)
      # => Total value of sales and all other outputs excluding any VAT. This corresponds to box 6 on the VAT Return form. The value must be between -9999999999999 and 9999999999999.
      t.integer :totalValueSalesExVAT

      # => totalValuePurchasesExVAT (Box 7)
      # => Total value of purchases and all other inputs excluding any VAT (including exempt purchases). This corresponds to box 7 on the VAT Return form. The value must be between -9999999999999 and 9999999999999.
      t.integer :totalValuePurchasesExVAT

      # => totalValueGoodsSuppliedExVAT (Box 8)
      # => Total value of all supplies of goods and related costs, excluding any VAT, to other EC member states. This corresponds to box 8 on the VAT Return form. The value must be between -9999999999999 and 9999999999999.
      t.integer :totalValueGoodsSuppliedExVAT

      # => totalValueGoodsSuppliedExVAT (Box 9)
      # => Total value of acquisitions of goods and related costs excluding any VAT, from other EC member states. This corresponds to box 9 on the VAT Return form. The value must be between -9999999999999 and 9999999999999.
      t.integer :totalAcquisitionsExVAT

      ########################
      ##       Extras       ##
      ########################

      # => TimeStamps
      # => Gives us the ability to determine when each record was created or updated
      t.timestamps

      ########################
      ########################

      # => Indexes
      # => Only work with user & returns that are unique
      t.index :periodKey,             unique: true, name: 'period_key_unique'      # => one record
      t.index [:user_id, :periodKey], unique: true, name: 'user_period_key_unique' # => one return per user

      ########################
      ########################

    end
  end #up

end

####################################################################
####################################################################
