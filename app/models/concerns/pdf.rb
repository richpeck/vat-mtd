##########################################################
##########################################################
##                  _________________                   ##
##                 | ___ \  _  \  ___|                  ##
##                 | |_/ / | | | |_                     ##
##                 |  __/| | | |  _|                    ##
##                 | |   | |/ /| |                      ##
##                 \_|   |___/ \_|                      ##
##                                                      ##
##########################################################
##########################################################

# => https://www.softcover.io/read/27309ccd/sinatra_cookbook/invoices
class Pdf < Prawn::Document

  def initialize order, *arguments
    super(*arguments)
    text "Packing Slip ##{order.number}", size: 24, style: :bold
    text "\n"
    text "Ship To", style: :bold
    text "\n"
    order.customer.attributes.except("id", "shop_id", "order_id", "properties", "created_at", "updated_at").each do |k,v|
      text v
    end
    text "\n"
    text "Items", style: :bold
    text "\n"
    order.line_items.each_with_index do |line_item, index|
      text "#{index + 1}. #{line_item.title}", style: :bold
      if line_item.try(:properties)
        line_item.properties.each do |k,v|
          text "#{k}: #{v}", size: 10
        end
      else
        text "(No Properties)"
      end
    end
  end

end
