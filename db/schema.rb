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

ActiveRecord::Schema.define(version: 2020_06_11_163544) do

  create_table "computers", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "model"
    t.text "description"
    t.string "form_factor"
    t.date "purchase_date"
    t.date "disposal_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["slug"], name: "index_computers_on_slug"
  end

  create_table "part_categories", force: :cascade do |t|
    t.string "name"
    t.string "name_singular"
    t.string "name_lowercase_plural"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.index ["slug"], name: "index_part_categories_on_slug"
  end

  create_table "part_categories_parts", id: false, force: :cascade do |t|
    t.integer "part_category_id", null: false
    t.integer "part_id", null: false
    t.index ["part_category_id"], name: "index_part_categories_parts_on_part_category_id"
    t.index ["part_id"], name: "index_part_categories_parts_on_part_id"
  end

  create_table "part_use_periods", force: :cascade do |t|
    t.integer "part_id"
    t.integer "computer_id"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["computer_id"], name: "index_part_use_periods_on_computer_id"
    t.index ["part_id"], name: "index_part_use_periods_on_part_id"
  end

  create_table "parts", force: :cascade do |t|
    t.string "model"
    t.string "name"
    t.string "part_number"
    t.text "specs"
    t.date "purchase_date"
    t.date "disposal_date"
    t.text "note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "manufacturer"
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

  add_foreign_key "part_use_periods", "computers"
  add_foreign_key "part_use_periods", "parts"
end
