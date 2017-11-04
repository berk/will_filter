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

ActiveRecord::Schema.define(version: 20120223232000) do

  create_table "event_users", force: :cascade do |t|
    t.integer "event_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["event_id", "user_id"], name: "index_event_users_on_event_id_and_user_id"
    t.index ["event_id"], name: "index_event_users_on_event_id"
    t.index ["user_id"], name: "index_event_users_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.integer "creator_id"
    t.string "type", limit: 255
    t.string "name", limit: 255
    t.string "headline", limit: 255
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float "rank"
    t.index ["creator_id"], name: "index_events_on_creator_id"
  end

  create_table "merchant_order_items", force: :cascade do |t|
    t.integer "order_id"
    t.string "name", limit: 255
    t.integer "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merchant_orders", force: :cascade do |t|
    t.integer "user_id"
    t.integer "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.date "birthday"
    t.string "sex", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "will_filter_filters", force: :cascade do |t|
    t.string "type", limit: 255
    t.string "name", limit: 255
    t.text "data"
    t.integer "user_id"
    t.string "model_class_name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_will_filter_filters_on_user_id"
  end

end
