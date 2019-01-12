class VlogVideoTag < ApplicationRecord
  has_many :vlog_video_tag_relationships
  has_many :vlog_videos, through: :vlog_video_tag_relationships
  
  validates :name, presence: true

end
