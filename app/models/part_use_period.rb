class PartUsePeriod < ApplicationRecord
  belongs_to :part
  belongs_to :computer

  validates :part, presence: true
  validates :purchase_date, presence: true
end
