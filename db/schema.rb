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

ActiveRecord::Schema.define(version: 2019_01_13_182842) do

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.string "author"
    t.string "amazon_id"
    t.date "completion_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subtitle"
    t.integer "page_count"
    t.string "book_type"
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
