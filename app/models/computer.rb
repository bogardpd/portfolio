class Computer < ApplicationRecord
  has_many :part_use_periods, dependent: :delete_all
  has_many :parts, through: :part_use_periods
  
  FORM_FACTORS = {desktop: "Desktop", laptop: "Laptop"}
  validates :name, presence: true
  validates :form_factor, inclusion: {in: FORM_FACTORS.keys.map(&:to_s), message: "%{value} is not a valid form factor."}
  validates :purchase_date, presence: true
  after_validation :generate_slug

  NEWLINE_ATTRS = %w(description)
  before_save :normalize_newlines

  CATEGORY_ORDER = %w(
    processors
    memory
    storage
    video-cards
    motherboards
    displays
    optical-drives
    power-supplies
    cases
    wi-fi-adapters
    webcams
    operating-systems
  )

  # Override to_param so forms use slugs.
  def to_param
    return self.slug
  end

  # Returns a hash with keys of PartCategories, and values of arrays of Parts
  # which have a PartUsePeriod with no end date associated with this Computer.
  def in_use_by_category
    parts = Part.joins(:part_use_periods).where(part_use_periods: {end_date: nil, computer: self})
    cpc = CategorizedPartCollection.new(parts, category_order: CATEGORY_ORDER)
    return cpc.groupings
  end

  # Returns a short name for the Computer for use in timelines.
  def chart_label
    if self.model.present?
      return "#{self.name} (#{self.model})"
    else
      return self.name
    end
  end

  def photo
    @photo ||= ExternalImage.new("electronics/computers/#{self.slug}.jpg")
    return @photo
  end

  # Returns an empty array. Used when we're pretending a computer is a Part
  # in an ElectronicsTimeline.
  def specs_array
    return Array.new
  end

  # Returns an ElectronicsTimeline SVG, grouped by category.
  def timeline
    cpc = CategorizedPartCollection.new(self.parts,
      category_order: CATEGORY_ORDER, computer: self)
    return cpc.timeline
  end

  

  # Returns an ElectronicsTimeline SVG for all computers.
  def self.all_computers_timeline
    ccc = CategorizedComputerCollection.new
    return ccc.timeline
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
