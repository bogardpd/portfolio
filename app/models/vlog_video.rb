class VlogVideo < ActiveRecord::Base
  validates :title, presence: true
  validates :youtube_id, presence: true
  validates :video_date, presence: true
  
end
