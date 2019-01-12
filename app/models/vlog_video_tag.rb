class VlogVideoTag < ActiveRecord::Base
  validates :name, presence: true
end
