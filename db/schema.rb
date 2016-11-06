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

ActiveRecord::Schema.define(version: 20161106233051) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_identities_on_user_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "to_id",        null: false
    t.integer  "from_id",      null: false
    t.text     "subject_line"
    t.text     "body"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "states", force: :cascade do |t|
    t.string   "short_name",        limit: 2
    t.string   "name"
    t.string   "slug"
    t.integer  "electoral_votes"
    t.integer  "optimistic_win_p"
    t.integer  "pessimistic_win_p"
    t.integer  "nov_win_p"
    t.integer  "win_margin"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.float    "chance_to_tip"
    t.index ["short_name"], name: "index_states_on_short_name", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",                          null: false
    t.string   "encrypted_password",     default: "",                          null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,                           null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "state",                                                        null: false
    t.string   "desired_candidate",                                            null: false
    t.string   "status",                 default: "unmatched",                 null: false
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.string   "name"
    t.integer  "match_id"
    t.text     "phone"
    t.uuid     "uuid",                   default: -> { "uuid_generate_v4()" }
    t.json     "match_preference"
    t.boolean  "match_strict"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["match_id"], name: "index_users_on_match_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "identities", "users"
  add_foreign_key "users", "users", column: "match_id"
end
