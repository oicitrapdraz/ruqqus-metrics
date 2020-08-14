# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_14_011611) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "guild_histories", force: :cascade do |t|
    t.bigint "guild_id", null: false
    t.jsonb "data"
    t.integer "subscribers_count"
    t.integer "mods_count"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index "((data -> 'is_banned'::text))", name: "index_guild_histories_on_is_banned"
    t.index "((data -> 'is_private'::text))", name: "index_guild_histories_on_is_private"
    t.index "((data -> 'is_restricted'::text))", name: "index_guild_histories_on_is_restricted"
    t.index "((data -> 'over_18'::text))", name: "index_guild_histories_on_over_18"
    t.index ["created_at"], name: "index_guild_histories_on_created_at"
    t.index ["guild_id"], name: "index_guild_histories_on_guild_id"
    t.index ["mods_count"], name: "index_guild_histories_on_mods_count"
    t.index ["subscribers_count"], name: "index_guild_histories_on_subscribers_count"
    t.index ["updated_at"], name: "index_guild_histories_on_updated_at"
  end

  create_table "guilds", force: :cascade do |t|
    t.string "name"
    t.jsonb "data"
    t.integer "subscribers_count"
    t.integer "mods_count"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index "((data -> 'is_banned'::text))", name: "index_guilds_on_is_banned"
    t.index "((data -> 'is_private'::text))", name: "index_guilds_on_is_private"
    t.index "((data -> 'is_restricted'::text))", name: "index_guilds_on_is_restricted"
    t.index "((data -> 'over_18'::text))", name: "index_guilds_on_over_18"
    t.index ["created_at"], name: "index_guilds_on_created_at"
    t.index ["mods_count"], name: "index_guilds_on_mods_count"
    t.index ["subscribers_count"], name: "index_guilds_on_subscribers_count"
    t.index ["updated_at"], name: "index_guilds_on_updated_at"
  end

  add_foreign_key "guild_histories", "guilds"
end
