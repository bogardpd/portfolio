class Part < ApplicationRecord
  has_and_belongs_to_many :part_categories
  validates :model, presence: true
  validates :purchase_date, presence: true

  def name_and_model
    if self.name.present?
      return "#{self.model} (“#{self.name}”)"
    else
      return self.model
    end
  end

end
