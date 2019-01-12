class CreateVlogVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :vlog_videos do |t|
      t.string :title
      t.string :youtube_id
      t.date :video_date
      t.string :vlog_day

      t.timestamps
    end
  end
end
