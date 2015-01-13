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

ActiveRecord::Schema.define(version: 20150113191706) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "access_tokens", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "authorization_id"
    t.uuid     "access_token",     null: false
    t.uuid     "refresh_token",    null: false
    t.boolean  "active",           null: false
    t.integer  "expires_in",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authorizations", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "client_application_id"
    t.uuid     "user_id"
    t.text     "state"
    t.text     "redirect_uri",          null: false
    t.text     "scopes",                             array: true
    t.uuid     "code",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "client_applications", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.text     "redirect_uri",  null: false
    t.uuid     "client_id",     null: false
    t.uuid     "client_secret", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "email",           null: false
    t.text     "password_digest", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
