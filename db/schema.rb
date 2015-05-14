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

ActiveRecord::Schema.define(version: 20150425203306) do

  create_table "companies", force: :cascade do |t|
    t.string   "company_name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "discs", force: :cascade do |t|
    t.string   "feld1"
    t.string   "feld2"
    t.integer  "tracks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "company_id"
    t.integer  "team_id"
    t.integer  "user_id"
  end

  add_index "discs", ["company_id"], name: "index_discs_on_company_id"
  add_index "discs", ["team_id"], name: "index_discs_on_team_id"
  add_index "discs", ["user_id"], name: "index_discs_on_user_id"

  create_table "profiles", force: :cascade do |t|
    t.string   "profile_first_name"
    t.string   "profile_last_name"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "profile_preferred_right_id"
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id"

  create_table "rights", force: :cascade do |t|
    t.integer  "right_role"
    t.integer  "user_id"
    t.integer  "company_id"
    t.integer  "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "rights", ["company_id"], name: "index_rights_on_company_id"
  add_index "rights", ["team_id"], name: "index_rights_on_team_id"
  add_index "rights", ["user_id"], name: "index_rights_on_user_id"

  create_table "teams", force: :cascade do |t|
    t.string   "team_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_account_name"
    t.integer  "user_system_role"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
