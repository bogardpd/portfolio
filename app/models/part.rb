class Part < ApplicationRecord
  has_and_belongs_to_many :part_categories
  has_many :part_use_periods, dependent: :delete_all
  has_many :computers, through: :part_use_periods

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
    return self.specs.lines.map(&:squish)
  end

  # Returns a hash with keys of PartCategories, and values of arrays of Parts
  # which have a PartUsePeriod with no end date associated with the specified
  # Computer (or with no Computer if computer is nil).
  def self.in_use_by_category(computer: nil)
    parts = Part.includes(:part_categories).joins(:part_use_periods).where(part_use_periods: {end_date: nil, computer: computer})
    category_ids = parts.joins(:part_categories).pluck(:part_category_id).uniq
    categories = Array(PartCategory.where(id: category_ids))

    if computer
      sort_order = PartCategory.table_order
      categories.sort_by!{|c| [sort_order[c.slug] || sort_order.size, c.name]}
    else
      categories.sort_by!{|c| c.name}
    end

    return categories.map{|c| [
      c,
      parts.select{|p|
        p.part_categories.include?(c)
      }
    ]}.to_h
  end

  private

  # Converts all textarea newlines to universal newlines
  def normalize_newlines
    NEWLINE_ATTRS.each{|attr| self[attr] = self[attr]&.encode(universal_newline: true)}
  end

end
