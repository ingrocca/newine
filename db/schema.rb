# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170719141418) do

  create_table "admins", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "crypted_password"
  end

  create_table "bottle_holders", force: true do |t|
    t.integer  "dispenser_id"
    t.integer  "wine_id"
    t.integer  "serving_volume_low"
    t.integer  "serving_volume_med"
    t.integer  "serving_volume_high"
    t.float    "serving_price_low"
    t.float    "serving_price_med"
    t.float    "serving_price_high"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dispenser_index"
    t.integer  "remaining_volume"
    t.integer  "actual_volume"
    t.boolean  "bottle_status"
    t.integer  "serving_volume_micro"
    t.boolean  "discounts",            default: false
    t.date     "date_bottle_change"
    t.date     "last_day_cleaned"
  end

  add_index "bottle_holders", ["dispenser_id"], name: "index_bottle_holders_on_dispenser_id"

  create_table "bottle_holders_special_events", force: true do |t|
    t.integer "bottle_holder_id"
    t.integer "special_event_id"
  end

  add_index "bottle_holders_special_events", ["bottle_holder_id"], name: "index_bottle_holders_special_events_on_bottle_holder_id"
  add_index "bottle_holders_special_events", ["special_event_id"], name: "index_bottle_holders_special_events_on_special_event_id"

  create_table "brands", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.integer  "low_percentage"
    t.integer  "med_percentage"
    t.integer  "high_percentage"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "complementary_drinks", force: true do |t|
    t.integer  "user_id"
    t.integer  "bottle_holder_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dispensers", force: true do |t|
    t.string   "uid"
    t.string   "name"
    t.datetime "last_registration"
    t.datetime "last_activity"
    t.boolean  "online"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "n_bottles"
    t.string   "ip"
    t.integer  "n_temperature_controls"
    t.boolean  "complementary_drink",    default: false
  end

  add_index "dispensers", ["online"], name: "index_dispensers_on_online"
  add_index "dispensers", ["uid"], name: "index_dispensers_on_uid"

  create_table "dispensers_special_events", force: true do |t|
    t.integer "dispenser_id"
    t.integer "special_event_id"
  end

  add_index "dispensers_special_events", ["dispenser_id"], name: "index_dispensers_special_events_on_dispenser_id"
  add_index "dispensers_special_events", ["special_event_id"], name: "index_dispensers_special_events_on_special_event_id"

  create_table "events", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "link_url"
    t.integer  "color"
    t.string   "event_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "servings", force: true do |t|
    t.string   "uid"
    t.integer  "bottle_index"
    t.integer  "serving_index"
    t.float    "price"
    t.integer  "volume"
    t.float    "remaining_credit"
    t.integer  "tag_id"
    t.integer  "bottle_holder_id"
    t.integer  "dispenser_id"
    t.integer  "wine_id"
    t.boolean  "valid_serving"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.float    "volume_cost",      default: 0.0
    t.string   "mode",             default: "self_serving"
  end

  add_index "servings", ["dispenser_id"], name: "index_servings_on_dispenser_id"
  add_index "servings", ["wine_id"], name: "index_servings_on_wine_id"

  create_table "special_events", force: true do |t|
    t.string   "name"
    t.integer  "percentage"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type_special_event"
    t.boolean  "active",             default: true
  end

  create_table "staffs", force: true do |t|
    t.string   "name"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tag_movements", force: true do |t|
    t.float    "credit"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "tags", force: true do |t|
    t.string  "uid"
    t.float   "credit"
    t.integer "user_id"
    t.boolean "active",   default: false
    t.date    "due_date"
  end

  add_index "tags", ["uid"], name: "index_tags_on_uid"
  add_index "tags", ["user_id"], name: "index_tags_on_user_id"

  create_table "temperature_controls", force: true do |t|
    t.integer  "dispenser_index"
    t.integer  "temperature"
    t.integer  "dispenser_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "temperature_controls", ["dispenser_id"], name: "index_temperature_controls_on_dispenser_id"

  create_table "users", force: true do |t|
    t.string  "name"
    t.boolean "can_clean"
    t.boolean "can_detach"
    t.boolean "can_set_temp"
    t.boolean "valid_user"
    t.string  "surname"
    t.string  "dni"
    t.string  "phone"
    t.string  "email"
    t.integer "category_id"
    t.integer "membership_number"
  end

  add_index "users", ["dni"], name: "index_users_on_dni"
  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["name"], name: "index_users_on_name"
  add_index "users", ["surname"], name: "index_users_on_surname"

  create_table "varieties", force: true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wines", force: true do |t|
    t.string   "name"
    t.text     "tasting_notes"
    t.text     "description"
    t.string   "brief"
    t.float    "bottle_cost"
    t.integer  "vintage"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "volume"
    t.integer  "serving_volume_low"
    t.integer  "serving_volume_med"
    t.integer  "serving_volume_high"
    t.float    "serving_price_low"
    t.float    "serving_price_med"
    t.float    "serving_price_high"
    t.integer  "open_days"
    t.integer  "variety_id"
    t.integer  "brand_id"
    t.float    "bottle_price",        default: 0.0
  end

  add_index "wines", ["name"], name: "index_wines_on_name"
  add_index "wines", ["vintage"], name: "index_wines_on_vintage"

end
