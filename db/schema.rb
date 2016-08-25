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

ActiveRecord::Schema.define(version: 20160825150301) do

  create_table "contracts", force: :cascade do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "customer_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.string   "title"
    t.date     "start_date"
    t.date     "end_date"
    t.date     "due_date"
    t.decimal  "total",         precision: 10, scale: 2
    t.string   "rent_phase_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "lineitems", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.string   "unit"
    t.decimal  "total",      precision: 10, scale: 2
    t.decimal  "unit_price", precision: 10, scale: 2
    t.string   "invoice_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "desc"
  end

  create_table "lineitmes", force: :cascade do |t|
    t.string   "desc"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "unit"
    t.decimal  "total",      precision: 10, scale: 2
    t.decimal  "unit_price", precision: 10, scale: 2
    t.string   "invoice_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "rent_phases", force: :cascade do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "cycle"
    t.decimal  "monthly_price", precision: 10, scale: 2
    t.string   "contract_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

end
