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

ActiveRecord::Schema.define(version: 2019_01_11_214254) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "consents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "title_translations"
    t.jsonb "content_translations"
    t.citext "key", null: false
    t.index ["key"], name: "index_consents_on_key", unique: true
  end

  create_table "user_consents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "consent_id"
    t.boolean "consented", default: false, null: false
    t.boolean "up_to_date", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consent_id", "user_id", "consented", "up_to_date"], name: "consented_to_index", where: "((consented = true) AND (up_to_date = true))"
    t.index ["consent_id"], name: "index_user_consents_on_consent_id"
    t.index ["consented", "up_to_date", "user_id", "id"], name: "valid_consents", where: "((consented = true) AND (up_to_date = true))"
    t.index ["user_id"], name: "index_user_consents_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "encrypted_password"
    t.string "encrypted_email_iv"
    t.string "encrypted_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_preferred_name_iv"
    t.string "encrypted_preferred_name"
    t.string "encrypted_username_iv"
    t.string "encrypted_username"
    t.uuid "uuid"
    t.index ["id", "encrypted_email", "encrypted_email_iv"], name: "user_email"
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

end
