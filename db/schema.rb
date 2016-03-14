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

ActiveRecord::Schema.define(version: 20160312182936) do

  create_table "constracts", force: :cascade do |t|
    t.string   "tour_code",          limit: 255
    t.string   "customer_id_number", limit: 255
    t.string   "company_name",       limit: 255
    t.string   "company_phone",      limit: 255
    t.string   "company_address",    limit: 255
    t.integer  "booking_tickets",    limit: 4
    t.integer  "total_money",        limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "places", force: :cascade do |t|
    t.string   "code",        limit: 255
    t.string   "name",        limit: 255
    t.string   "city",        limit: 255
    t.string   "country",     limit: 255
    t.string   "address",     limit: 255
    t.text     "services",    limit: 65535
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "tours", force: :cascade do |t|
    t.string   "code",              limit: 255
    t.string   "place_code",        limit: 255
    t.date     "start_date"
    t.integer  "tickets",           limit: 4
    t.integer  "available_tickets", limit: 4
    t.integer  "cost",              limit: 4
    t.text     "description",       limit: 65535
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

end
