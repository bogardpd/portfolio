class VlogVideoTag < ApplicationRecord
  has_many :vlog_video_tag_relationships
  has_many :vlog_videos, through: :vlog_video_tag_relationships
  accepts_nested_attributes_for :vlog_videos
  
  validates :name, presence: true

end
