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
    # return Part.in_use_by_category(computer: self)
    parts = Part.joins(:part_use_periods).where(part_use_periods: {end_date: nil, computer: self})
    return parts.group_by_category(sort_order: CATEGORY_ORDER)
  end

  def photo
    @photo ||= ExternalImage.new("electronics/computers/#{self.slug}.jpg")
    return @photo
  end

  # Returns an ElectronicsTimeline SVG, grouped by category.
  def timeline
    return self.parts.timeline(category_order: CATEGORY_ORDER)
  end

  

  # Returns an ElectronicsTimeline SVG for all computers.
  def self.all_computers_timeline
    form_factor_groups = Computer.all.includes(:part_use_periods).group_by{|c| c.form_factor}
    grouped_categories = Hash.new()
    FORM_FACTORS.each do |form_factor, name|
      # Create grouped categories, treating each Computer as a Part:
      computers = form_factor_groups[form_factor.to_s]
      if computers && computers.any?
        computers = computers.map do |c|
          part_attr = {
            model: c.model,
            name: c.name,
            purchase_date: c.purchase_date,
            disposal_date: c.disposal_date,
            part_use_periods: merge_overlapping_part_use_periods(c.part_use_periods)
          }          
          next Part.new(part_attr)
        end
        category = PartCategory.new(name: name.pluralize)
        grouped_categories[category] = computers
      end
    end
    # return grouped_categories
    return ElectronicsTimeline.new(grouped_categories: grouped_categories).svg_xml.html_safe
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

  # Determines Computer use periods by merging overlapping PartUsePeriods for
  # the Computer's Parts.
  def self.merge_overlapping_part_use_periods(use_periods)
    date_ranges = use_periods.map{|u| u.start_date...u.end_date}
    merged_date_ranges = date_ranges.sort_by(&:begin).inject([]) do |ranges, range|
      if ranges.any? && use_period_ranges_overlap?(ranges.last, range)
        next ranges[0...-1] + [merge_use_period_ranges(ranges.last, range)]
      else
        next ranges + [range]
      end
    end
    return merged_date_ranges.map{|pu| PartUsePeriod.new(start_date: pu.begin, end_date: pu.end)}
  end

  # Merges two overlapping PartUsePeriod date ranges into a single date range.
  def self.merge_use_period_ranges(a, b)
    ends = [a.end, b.end]
    max_end = ends.include?(nil) ? nil : ends.max
    return [a.begin, b.begin].min...max_end
  end

  # Checks if two PartUsePeriod date ranges overlap.
  def self.use_period_ranges_overlap?(a, b)
    return true if a.end.nil? && b.end.nil?
    a_includes_b_begin = a.end.nil? ? (b.end > a.begin) : a.include?(b.begin)
    b_includes_a_begin = b.end.nil? ? (a.end > b.begin) : b.include?(a.begin)
    return a_includes_b_begin || b_includes_a_begin
  end

end
