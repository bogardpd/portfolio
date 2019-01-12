class VlogVideoTagRelationship < ApplicationRecord
  belongs_to :vlog_video
  belongs_to :vlog_video_tag
end
