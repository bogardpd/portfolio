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

  CATEGORY_ORDER = %w(processors motherboards displays video-cards memory storage optical-drives power-supplies cases wi-fi-adapters webcams operating-systems)

  # Override to_param so forms use slugs.
  def to_param
    return self.slug
  end

  # Returns a hash with keys of PartCategories, and values of arrays of Parts
  # which have a PartUsePeriod with no end date associated with this Computer.
  def in_use_by_category
    # return Part.in_use_by_category(computer: self)
    parts = Part.joins(:part_use_periods).where(part_use_periods: {end_date: nil, computer: self})
    return parts.group_by_category(sort_order: CATEGORY_ORDER)
  end

  def photo
    @photo ||= ExternalImage.new("electronics/computers/#{self.slug}.jpg")
    return @photo
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
