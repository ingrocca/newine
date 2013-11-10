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

ActiveRecord::Schema.define(version: 20131109224444) do

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
  end

  create_table "tags", force: true do |t|
    t.string  "uid"
    t.float   "credit"
    t.integer "user_id"
  end

  create_table "users", force: true do |t|
    t.string  "name"
    t.boolean "can_clean"
    t.boolean "can_detach"
    t.boolean "can_set_temp"
    t.boolean "valid_user"
  end

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
  end

end
