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

ActiveRecord::Schema.define(version: 20130921201810) do

  create_table "fable", force: true do |t|
    t.string   "guid"
    t.string   "name"
    t.date     "date_added"
    t.integer  "length_in_sec"
    t.integer  "is_paid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "language"
  end

  create_table "purchased_fable", force: true do |t|
    t.integer  "user_id"
    t.integer  "fable_id"
    t.date     "date_purchased"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user", force: true do |t|
    t.string   "apple_id"
    t.string   "push_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
