class DropBooks < ActiveRecord::Migration[5.2]
  def change
    drop_table :books do |t|
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
  end
end
