# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 1) do

  create_table "returns", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "periodKey", null: false
    t.date "start_date"
    t.date "end_date"
    t.date "due_date"
    t.string "status"
    t.decimal "vatDueSales", precision: 13, scale: 2
    t.decimal "vatDueAcquisitions", precision: 13, scale: 2
    t.decimal "vatDueDue", precision: 13, scale: 2
    t.decimal "vatReclaimedCurrPeriod", precision: 13, scale: 2
    t.decimal "netVatDue", precision: 11, scale: 2
    t.integer "totalValueSalesExVAT"
    t.integer "totalValuePurchasesExVAT"
    t.integer "totalValueGoodsSuppliedExVAT"
    t.integer "totalAcquisitionsExVAT"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["periodKey"], name: "period_key_unique", unique: true
    t.index ["user_id", "periodKey"], name: "user_period_key_unique", unique: true
    t.index ["user_id"], name: "index_returns_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "vrn", limit: 9
    t.string "last_signed_in_ip"
    t.datetime "last_signed_in_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "email_unique", unique: true
  end

end
