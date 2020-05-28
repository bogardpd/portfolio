class PartUsePeriod < ApplicationRecord
  belongs_to :part
  belongs_to :computer

  validates :part_id, presence: true
  validates :start_date, presence: true

  scope :current, -> { where(end_date: nil) }

end
