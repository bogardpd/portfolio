class Part < ApplicationRecord
  has_and_belongs_to_many :part_categories
  validates :model, presence: true
  validates :purchase_date, presence: true

  NEWLINE_ATTRS = %w(specs note)
  before_save :normalize_newlines

  def name_and_model
    if self.name.present?
      return "#{self.model} (“#{self.name}”)"
    else
      return self.model
    end
  end

  def specs_array
    # return ["a"] unless self.specs.present?
    return self.specs.lines.map(&:squish)
  end

  private

  # Converts all textarea newlines to universal newlines
  def normalize_newlines
    NEWLINE_ATTRS.each {|attr| self[attr] = self[attr].encode(universal_newline: true)}
  end

end