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

ActiveRecord::Schema.define(version: 2014_04_13_221333) do

  create_table "associations", force: :cascade do |t|
    t.string "associatiable_type"
    t.integer "associatiable_id"
    t.string "associated_type"
    t.integer "associated_id"
    t.text "properties"
    t.integer "variant_id", limit: 8
    t.string "variant_title"
    t.index ["associated_type", "associated_id"], name: "index_associations_on_associated_type_and_associated_id"
    t.index ["associatiable_type", "associatiable_id", "associated_type", "associated_id"], name: "association_index", unique: true
    t.index ["associatiable_type", "associatiable_id"], name: "index_associations_on_associatiable_type_and_associatiable_id"
  end

  create_table "customers", force: :cascade do |t|
    t.integer "shop_id"
    t.integer "order_id"
    t.string "email"
    t.string "name"
    t.string "phone"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "province"
    t.string "zip"
    t.string "country"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id", "shop_id"], name: "order_and_shop_rpeck_unique_index", unique: true
    t.index ["order_id"], name: "index_customers_on_order_id"
    t.index ["shop_id"], name: "index_customers_on_shop_id"
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "shop_id"
    t.integer "product_id", limit: 8
    t.string "vendor"
    t.string "title"
    t.string "sku"
    t.text "url"
    t.text "image"
    t.decimal "price", precision: 10, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id", "shop_id"], name: "product_id_shop_id_rpeck_unique_index", unique: true
    t.index ["shop_id"], name: "index_line_items_on_shop_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "shop_id"
    t.integer "order_id", limit: 8
    t.integer "pwinty_id", limit: 8
    t.integer "number", limit: 8
    t.text "status"
    t.decimal "total_price", precision: 10, scale: 2
    t.decimal "subtotal_price", precision: 10, scale: 2
    t.decimal "shipping_price", precision: 10, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["pwinty_id"], name: "pwinty_unique_index", unique: true
    t.index ["shop_id", "order_id"], name: "shop_and_order_rpeck_unique_index", unique: true
    t.index ["shop_id"], name: "index_orders_on_shop_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "token_encrypted"
    t.boolean "pwinty_auto", default: false
    t.boolean "email_notifications", default: false
    t.index ["name"], name: "index_shops_on_name", unique: true
  end

end
