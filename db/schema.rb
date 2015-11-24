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

ActiveRecord::Schema.define(version: 20150928044955) do

  create_table "aadhiconfigs", force: :cascade do |t|
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.string   "server_mode",          limit: 7,     default: "default"
    t.string   "isProxyRequired",      limit: 3,     default: "no"
    t.text     "url",                  limit: 65535
    t.string   "port",                 limit: 255
    t.string   "user",                 limit: 255
    t.string   "password",             limit: 255
    t.text     "bypass_proxy_domains", limit: 65535
  end

  create_table "device_reports", force: :cascade do |t|
    t.string   "device_ip",  limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "device_scenarios", force: :cascade do |t|
    t.string   "scenario_name",    limit: 255
    t.integer  "device_report_id", limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "device_scenarios", ["device_report_id"], name: "index_device_scenarios_on_device_report_id", using: :btree

  create_table "devices", force: :cascade do |t|
    t.string   "device_ip",        limit: 255
    t.integer  "scenario_id",      limit: 4
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "isReportRequired", limit: 3,   default: "no"
  end

  add_index "devices", ["scenario_id"], name: "index_devices_on_scenario_id", using: :btree

  create_table "features", force: :cascade do |t|
    t.string   "feature_name", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "features", ["feature_name"], name: "index_features_on_feature_name", unique: true, using: :btree

  create_table "flows", force: :cascade do |t|
    t.string   "flow_name",  limit: 255
    t.integer  "feature_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "flows", ["feature_id"], name: "index_flows_on_feature_id", using: :btree
  add_index "flows", ["flow_name"], name: "index_flows_on_flow_name", unique: true, using: :btree

  create_table "notfounds", force: :cascade do |t|
    t.text     "url",           limit: 4294967295
    t.string   "scenario_name", limit: 255
    t.string   "device_ip",     limit: 255
    t.string   "method",        limit: 255
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "routes", force: :cascade do |t|
    t.string   "route_type",   limit: 255
    t.text     "path",         limit: 4294967295
    t.text     "query",        limit: 4294967295
    t.text     "request_body", limit: 4294967295
    t.text     "fixture",      limit: 4294967295
    t.string   "status",       limit: 255,        default: "200"
    t.integer  "scenario_id",  limit: 4
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.text     "host",         limit: 4294967295
  end

  add_index "routes", ["scenario_id"], name: "index_routes_on_scenario_id", using: :btree

  create_table "scenario_routes", force: :cascade do |t|
    t.text     "path",               limit: 4294967295
    t.string   "route_type",         limit: 255
    t.text     "fixture",            limit: 4294967295
    t.integer  "count",              limit: 4,          default: 0
    t.integer  "device_scenario_id", limit: 4
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "status",             limit: 255
  end

  add_index "scenario_routes", ["device_scenario_id"], name: "index_scenario_routes_on_device_scenario_id", using: :btree

  create_table "scenarios", force: :cascade do |t|
    t.string   "scenario_name", limit: 255
    t.integer  "flow_id",       limit: 4
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "isTemp",        limit: 3,   default: "no"
  end

  add_index "scenarios", ["flow_id"], name: "index_scenarios_on_flow_id", using: :btree
  add_index "scenarios", ["scenario_name"], name: "index_scenarios_on_scenario_name", unique: true, using: :btree

  create_table "stubs", force: :cascade do |t|
    t.text     "request_url",  limit: 4294967295
    t.text     "route_type",   limit: 4294967295
    t.text     "request_body", limit: 4294967295
    t.text     "response",     limit: 4294967295
    t.text     "status",       limit: 4294967295
    t.text     "host",         limit: 4294967295
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.text     "remote_ip",    limit: 4294967295
    t.text     "headers",      limit: 4294967295
  end

  add_foreign_key "device_scenarios", "device_reports"
  add_foreign_key "devices", "scenarios"
  add_foreign_key "flows", "features"
  add_foreign_key "routes", "scenarios"
  add_foreign_key "scenario_routes", "device_scenarios"
  add_foreign_key "scenarios", "flows"
end
