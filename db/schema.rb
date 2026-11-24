# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_11_24_142904) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "properties", force: :cascade do |t|
    t.string "title"
    t.decimal "price", precision: 12, scale: 2
    t.integer "bedrooms"
    t.string "property_type"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bedrooms"], name: "index_properties_on_bedrooms"
    t.index ["price"], name: "index_properties_on_price"
    t.index ["property_type"], name: "index_properties_on_property_type"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "watchlist_items", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "property_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_watchlist_items_on_property_id"
    t.index ["user_id", "property_id"], name: "index_watchlist_items_on_user_id_and_property_id", unique: true
    t.index ["user_id"], name: "index_watchlist_items_on_user_id"
  end

  add_foreign_key "watchlist_items", "properties"
  add_foreign_key "watchlist_items", "users"
end
