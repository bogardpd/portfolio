class VlogVideoTag < ApplicationRecord
  has_many :vlog_video_tag_relationships
  has_many :vlog_videos, through: :vlog_video_tag_relationships
  accepts_nested_attributes_for :vlog_videos
  
  validates :name,               presence: true, uniqueness: true
  validates :parameterized_name, presence: true, uniqueness: true

  before_validation :create_parameterized_name

  private

  def create_parameterized_name
    self.parameterized_name = ParameterString::format(self.name)
  end

end
