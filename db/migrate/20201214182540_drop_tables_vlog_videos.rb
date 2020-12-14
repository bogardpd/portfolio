class DropTablesVlogVideos < ActiveRecord::Migration[6.0]
  def change
    drop_table :vlog_video_tag_relationships
    drop_table :vlog_video_tags
    drop_table :vlog_videos
  end
end
