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

ActiveRecord::Schema.define(version: 20131216003520) do

  create_table "admins", force: true do |t|
    t.string   "username"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "is_super_admin"
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
  end

  add_index "bottle_holders", ["dispenser_id"], name: "index_bottle_holders_on_dispenser_id"

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
  end

  add_index "dispensers", ["online"], name: "index_dispensers_on_online"
  add_index "dispensers", ["uid"], name: "index_dispensers_on_uid"

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
  end

  add_index "servings", ["dispenser_id"], name: "index_servings_on_dispenser_id"
  add_index "servings", ["wine_id"], name: "index_servings_on_wine_id"

  create_table "tags", force: true do |t|
    t.string  "uid"
    t.float   "credit"
    t.integer "user_id"
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
    t.string  "client_type"
  end

  add_index "users", ["dni"], name: "index_users_on_dni"
  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["name"], name: "index_users_on_name"
  add_index "users", ["surname"], name: "index_users_on_surname"

  create_table "wines", force: true do |t|
    t.string   "name"
    t.string   "brand"
    t.text     "tasting_notes"
    t.text     "description"
    t.string   "brief"
    t.float    "bottle_cost"
    t.integer  "vintage"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "variety"
    t.integer  "volume"
    t.integer  "serving_volume_low"
    t.integer  "serving_volume_med"
    t.integer  "serving_volume_high"
    t.float    "serving_price_low"
    t.float    "serving_price_med"
    t.float    "serving_price_high"
  end

  add_index "wines", ["brand"], name: "index_wines_on_brand"
  add_index "wines", ["name"], name: "index_wines_on_name"
  add_index "wines", ["variety"], name: "index_wines_on_variety"
  add_index "wines", ["vintage"], name: "index_wines_on_vintage"

end
