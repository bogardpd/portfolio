class PartCategory < ApplicationRecord
  has_and_belongs_to_many :parts
  validates :name, presence: true

end
