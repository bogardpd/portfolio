class VlogVideo < ApplicationRecord
  has_many :vlog_video_tag_relationships
  has_many :vlog_video_tags, through: :vlog_video_tag_relationships
  accepts_nested_attributes_for :vlog_video_tags
  
  validates :title, presence: true
  validates :youtube_id, presence: true
  validates :video_date, presence: true

  def details
    # Returns a formatted string of vlog day and date, if present.
    details = Array.new
    details.push("Day #{self.vlog_day}") if self.vlog_day.present?
    details.push(FormattedDate::text(self.video_date).to_s) if self.video_date.present?
    return details
  end

  def tags
    # Returns an array of id/name hashes of tags for the video
    return self.vlog_video_tags.order(name: :asc).map{|t| {id: t.id, name: t.name}}
  end
end
