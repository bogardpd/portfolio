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

ActiveRecord::Schema.define(version: 2020_05_23_170339) do

  create_table "computers", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "model"
    t.string "description"
    t.string "form_factor"
    t.date "purchase_date"
    t.date "disposal_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["slug"], name: "index_computers_on_slug"
  end

  create_table "terminal_silhouettes", force: :cascade do |t|
    t.string "iata_code"
    t.string "city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "vlog_video_tag_relationships", force: :cascade do |t|
    t.integer "vlog_video_id"
    t.integer "vlog_video_tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vlog_video_id", "vlog_video_tag_id"], name: "vlog_tag_relationships"
  end

  create_table "vlog_video_tags", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "parameterized_name"
    t.index ["parameterized_name"], name: "index_vlog_video_tags_on_parameterized_name"
  end

  create_table "vlog_videos", force: :cascade do |t|
    t.string "title"
    t.string "youtube_id"
    t.date "video_date"
    t.string "vlog_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
