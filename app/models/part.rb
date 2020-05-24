class Part < ApplicationRecord
  has_and_belongs_to_many :part_categories
  validates :model, presence: true
  validates :purchase_date, presence: true

end
