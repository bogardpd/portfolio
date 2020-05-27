class Computer < ApplicationRecord
  has_many :part_use_periods, dependent: :delete_all
  has_many :parts, through: :part_use_periods
  
  FORM_FACTORS = {laptop: "Laptop", desktop: "Desktop"}
  validates :name, presence: true
  validates :form_factor, inclusion: {in: FORM_FACTORS.keys.map(&:to_s), message: "%{value} is not a valid form factor."}
  validates :purchase_date, presence: true
  after_validation :generate_slug

  NEWLINE_ATTRS = %w(description)
  before_save :normalize_newlines

  # Override to_param so forms use slugs.
  def to_param
    return self.slug
  end

  # Returns a hash with keys of PartCategories, and values of arrays of Parts
  # which have a PartUsePeriod with no end date associated with this Computer.
  def current_parts_by_category
    sort_order = PartCategory.table_order
    current_uses = self.part_use_periods.includes(part: :part_categories).where(end_date: nil)
    current_parts = current_uses.map{|u| u.part}
    categories = current_parts.map{|p| p.part_categories.first}
    categories.sort_by!{|c| [sort_order[c.slug] || sort_order.size, c.name]}
    return categories.map{|c| [
      c,
      current_parts.select{|cp|
        cp.part_categories && cp.part_categories.include?(c)
      }
    ]}.to_h
  end

  private

  # Generate a unique slug.
  def generate_slug
    self.slug = Slug.generate(Computer, self.name, self.name_was, self.slug_was)
  end
  
  # Converts all textarea newlines to universal newlines
  def normalize_newlines
    NEWLINE_ATTRS.each{|attr| self[attr] = self[attr]&.encode(universal_newline: true)}
  end

end
