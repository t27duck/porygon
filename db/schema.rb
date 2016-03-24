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

ActiveRecord::Schema.define(version: 1003) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pokemons", force: :cascade do |t|
    t.string   "name",                      null: false
    t.integer  "national_dex",              null: false
    t.string   "types",        default: [], null: false, array: true
    t.string   "species",                   null: false
    t.text     "descriptions", default: [], null: false, array: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "pokemons", ["national_dex"], name: "index_pokemons_on_national_dex", unique: true, using: :btree

  create_table "raw_chat_logs", force: :cascade do |t|
    t.string   "channel",                    null: false
    t.integer  "event",                      null: false
    t.string   "nick",                       null: false
    t.string   "host",                       null: false
    t.text     "message",                    null: false
    t.boolean  "parsed",     default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.date     "created_on",                 null: false
  end

  add_index "raw_chat_logs", ["channel"], name: "index_raw_chat_logs_on_channel", using: :btree
  add_index "raw_chat_logs", ["created_at"], name: "index_raw_chat_logs_on_created_at", using: :btree
  add_index "raw_chat_logs", ["created_on"], name: "index_raw_chat_logs_on_created_on", using: :btree
  add_index "raw_chat_logs", ["event"], name: "index_raw_chat_logs_on_event", using: :btree

end
