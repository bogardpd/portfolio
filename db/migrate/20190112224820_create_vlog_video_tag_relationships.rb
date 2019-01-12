class CreateVlogVideoTagRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :vlog_video_tag_relationships do |t|
      t.integer :vlog_video_id
      t.integer :vlog_video_tag_id

      t.timestamps
    end

    add_index :vlog_video_tag_relationships, [:vlog_video_id, :vlog_video_tag_id], name: "vlog_tag_relationships"
  end
end
