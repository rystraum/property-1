# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110723040032) do

  create_table "agencies", :force => true do |t|
    t.string   "name"
    t.integer  "admin_id"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "listings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "property_id"
    t.string   "title"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
    t.integer  "land_area"
    t.boolean  "list_as_land",                     :default => false
    t.integer  "residence_area"
    t.string   "residence_construction"
    t.boolean  "beach_front"
    t.boolean  "near_beach"
    t.string   "residence_type"
    t.text     "description"
    t.integer  "selling_price"
    t.integer  "rent_per_day"
    t.integer  "rent_per_week"
    t.integer  "rent_per_month"
    t.integer  "rent_per_month_biannual_contract"
    t.integer  "rent_per_month_annual_contract"
    t.date     "available_on"
    t.boolean  "anonymous"
    t.string   "contact_name"
    t.string   "contact_phone"
    t.string   "contact_email"
    t.text     "contact_note"
    t.string   "lister_interest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "listings", ["user_id"], :name => "index_listings_on_user_id"

  create_table "properties", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searches", :force => true do |t|
    t.integer  "user_id"
    t.string   "address"
    t.boolean  "for_sale"
    t.boolean  "for_rent"
    t.boolean  "native"
    t.boolean  "basic"
    t.boolean  "modern"
    t.boolean  "elegant"
    t.boolean  "house"
    t.boolean  "apartment"
    t.boolean  "chalet"
    t.boolean  "private_room"
    t.boolean  "shared_room"
    t.boolean  "land"
    t.boolean  "commercial"
    t.string   "rental_term"
    t.integer  "for_sale_min_price"
    t.integer  "for_sale_max_price"
    t.integer  "for_rent_min_price"
    t.integer  "for_rent_max_price"
    t.string   "center"
    t.string   "sw_bounds"
    t.string   "ne_bounds"
    t.integer  "zoom"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.integer  "agency_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
