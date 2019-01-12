class CreateVlogVideoTags < ActiveRecord::Migration[5.2]
  def change
    create_table :vlog_video_tags do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
