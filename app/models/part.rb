class Part < ApplicationRecord
  has_and_belongs_to_many :part_categories
  has_many :part_use_periods, dependent: :delete_all
  has_many :computers, through: :part_use_periods

  validates :model, presence: true
  validates :purchase_date, presence: true

  NEWLINE_ATTRS = %w(specs note)
  before_save :normalize_newlines

  # Returns the model and name (if present) of the Part.
  def name_and_model
    return Part.name_and_model(self.name, self.model)
  end

  # Returns the model and name of an arbitrary part.
  def self.name_and_model(name, model)
    if name.present?
      return "#{model} (“#{name}”)"
    else
      return model
    end
  end

  def photo
    return nil unless self.part_number
    path = "electronics/parts/"
    path += "#{self.manufacturer.parameterize}/" if self.manufacturer.present?
    path += "#{self.part_number.parameterize}.jpg" 
    @photo ||= ExternalImage.new(path)
    return @photo
  end

  # Return an array of part specs.
  def specs_array
    return self.specs.lines.map(&:squish)
  end

  # Returns a CategorizedPartCollection of Parts which have a PartUsePeriod with
  # no end date not associated with any Computer.
  def self.current_no_computer
    parts = Part.joins(:part_use_periods).where(part_use_periods: {end_date: nil, computer: nil})
    return CategorizedPartCollection.new(parts: parts)
  end

  # Creates an SVG timeline for an ActiveRecord association of Parts.
  def self.timeline(category_order: nil, computer: nil)
    parts = self.all
    return nil unless parts.any?
    return CategorizedPartCollection.new(parts: parts).timeline
  end

  private

  # Converts all textarea newlines to universal newlines
  def normalize_newlines
    NEWLINE_ATTRS.each{|attr| self[attr] = self[attr]&.encode(universal_newline: true)}
  end

end
