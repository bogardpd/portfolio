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
  # which have a PartUsePeriod with no end date not associated with any
  # Computer.
  def self.in_use_no_computer_by_category
    parts = Part.joins(:part_use_periods).where(part_use_periods: {end_date: nil, computer: nil})
    return parts.group_by_category
  end

  # Groups an ActiveRecord Association of Parts into PartCategories. If a part
  # has multiple categories, it will be placed into all categories it matches.
  #
  # @param sort_order [Array, nil] an array of PartCategory slug strings
  #   specifying the order in which to sort the categories. PartCategories not
  #   in the array will be placed after the specified category and sorted
  #   alphabetically by name. If sort_order is not provided, all categories
  #   will be sorted alphabetically by name.
  # @return [Hash] a hash with PartCategories as keys and arrays of Parts as
  #   values
  def self.group_by_category(sort_order: nil)
    parts = self.includes(:part_categories)
    category_ids = parts.joins(:part_categories).map{|p| p.part_categories.pluck(:id)}.flatten.uniq
    categories = Array(PartCategory.where(id: category_ids))

    if sort_order
      lookup = sort_order.to_enum.with_index.to_h
      categories.sort_by!{|c| [lookup[c.slug] || lookup.size, c.name]}
    else
      categories.sort_by!{|c| c.name}
    end

    return categories.map{|c| [
      c,
      Array(parts).uniq.select{|p|
        p.part_categories.include?(c)
      }
    ]}.to_h
  end

  # Creates an SVG timeline for an ActiveRecord association of Parts.
  def self.timeline(category_order: nil)
    parts = self.all
    return nil unless parts.any?
    return ElectronicsTimeline.new(parts, category_order: category_order).svg_xml.html_safe
  end

  private

  # Converts all textarea newlines to universal newlines
  def normalize_newlines
    NEWLINE_ATTRS.each{|attr| self[attr] = self[attr]&.encode(universal_newline: true)}
  end

end
