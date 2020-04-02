##########################################################
##########################################################
##                  ___                                 ##
##                 / _ \                                ##
##                / /_\ \_ __  _ __                     ##
##                |  _  | '_ \| '_ \                    ##
##                | | | | |_) | |_) |                   ##
##                \_| |_/ .__/| .__/                    ##
##                      | |   | |                       ##
##                      |_|   |_|                       ##
##                                                      ##
##########################################################
##########################################################

## Libs ##
## These are in vendor/assets because Rails-Assets was down
#= require jquery-3.4.1.min
#= require datatables.min

##########################################################
##########################################################

## Flash ##
## Allows us to close the flash alerts on command ##
$(document).on "click", ".flash", (e)->

  ## Fade Out ##
  ## After this, remove from the DOM ##
  $(this).fadeOut "150", ->
    $(this).remove()

##########################################################
##########################################################

## Datatable ##
## This allows us to populate the orders table with specific information ##
$(document).ready (e)->

  ## Vars ##
  table   = $("table#orders")
  options = $("form#options")

  ## Init ##
  ## This creates the datatable out of the normal HTML table
  if table.length > 0
    table.DataTable()

  ## Options ##
  ## Allows us to change/manage options from the top menu ##
  options.on "change", 'input[type="checkbox"]', (e)->
    e.preventDefault()
    $.post(options.attr("action"), options.serialize()).done ->
      if window.hasOwnProperty("ShopifyApp") then ShopifyApp.flashNotice("Updated")

##########################################################
##########################################################
