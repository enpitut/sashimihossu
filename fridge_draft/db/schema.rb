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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150824005355) do

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.float    "amount_at_a_time"
    t.float    "gram_at_a_time"
    t.float    "price_at_a_time"
    t.float    "price_at_one_amount"
    t.float    "price_at_one_gram"
    t.text     "description"
    t.binary   "icon"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "user_items", force: :cascade do |t|
    t.integer  "user_id",          null: false
    t.integer  "item_id",          null: false
    t.float    "remaining_amount"
    t.float    "remaining_gram"
    t.string   "title"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.integer  "grade"
    t.integer  "point"
    t.text     "description"
    t.string   "sex"
    t.string   "age"
    t.binary   "icon"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end