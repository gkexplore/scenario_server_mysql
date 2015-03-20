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

ActiveRecord::Schema.define(version: 20150127074053) do

  create_table "flows", force: :cascade do |t|
    t.text     "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prerequisites", force: :cascade do |t|
    t.text     "service_array_comma_separated"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "flow_id"
  end

  add_index "prerequisites", ["flow_id"], name: "index_prerequisites_on_flow_id"

  create_table "routes", force: :cascade do |t|
    t.text     "route_type"
    t.text     "path"
    t.text     "request_body"
    t.text     "fixture"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "status"
    t.integer  "scenario_id"
  end

  add_index "routes", ["scenario_id"], name: "index_routes_on_scenario_id"

  create_table "scenarios", force: :cascade do |t|
    t.text     "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "flow_id"
  end

  add_index "scenarios", ["flow_id"], name: "index_scenarios_on_flow_id"

end
