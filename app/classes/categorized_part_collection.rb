# Holds a collection of Parts, grouped by their PartCategories. If a part has
# multiple categories, it will show up under each category.
class CategorizedPartCollection

  # Initializes a CategorizedPartCollection. Must specify either `parts` or
  # `computers` (but not both).
  # @param parts [Array<Part>] an array or ActiveRecord collection of Parts
  # @param computers [Array<Computer>] an array or ActiveRecord collection of
  #   Computers
  # @param single_category [Boolean] If true, all parts will be grouped under
  #   a single nil category.
  # @param category_order [Array] an array of PartCategory slug strings
  #   specifying the order in which to sort the categories. PartCategories not
  #   in the array will be placed after the specified category and sorted
  #   alphabetically by name. If sort_order is not provided, all categories
  #   will be sorted alphabetically by name.
  # @param comparison_computer [Computer] the Computer all of the parts belong
  #   to, if any. Used for Computer timelines to decorate PartUsePeriod bars
  #   associated with this computer versus uses of the same Part in other
  #   computers.
  def initialize(parts: nil, computers: nil, single_category: nil, category_order: nil, comparison_computer: nil)
    if [parts, computers].select(&:present?).count > 1
      raise ArgumentError, "May not specify both parts and computers"
    end
    @single_category = single_category
    @category_order = category_order
    @comparison_computer = comparison_computer
    if computers
      @groupings = group_computers_by_category(computers)
    elsif parts
      @groupings = group_parts_by_category(parts)
    else
      return nil
    end
    @parts = @groupings.map{|g| g[:items]}.flatten.uniq

  end

  # Returns an array of all parts
  def parts
    return @parts
  end

  # Returns the range between the minimum purchase date and maximum
  # disposal date.
  def date_range
    return nil unless @parts.any?
    min = @parts.min_by{|p| p[:owned].begin}[:owned].begin
    if @parts.any?{|p| p[:owned].end.nil?}
      max = nil
    else
      max = @parts.max_by{|p| p[:owned].end}[:owned].end
    end
    return (min...max)
  end

  # Returns an array of part categories, with hashes containing the category
  # name and an array of part details for parts in the category.
  def groupings
    return @groupings
  end

  # Returns an ElectronicsTimeline for this instance's data.
  def timeline(include_tooltip_divs: true)
    et = ElectronicsTimeline.new(self)
    output = et.svg_xml
    return output.html_safe
  end

  # Creates a string for unique tooltip ids.  
  def self.tooltip_id(item_id)
    return "#{item_id}-tooltip-content"
  end

  private

  def group_computers_by_category(computers)
    computers = computers.includes(:part_use_periods)
    groupings = computers.group_by{|c| c.form_factor}.map do |ff, ff_computers|
      category = Computer::FORM_FACTORS[ff.to_sym].pluralize
      computer_details = ff_computers.map do |computer|
        uses = merge_overlapping_part_use_periods(computer.part_use_periods)
        uses = uses.map{|u| [u, {other_computer: false}]}.to_h
        next {
          id: "computer-#{computer.id}",
          name: computer.name.present? ? computer.name : nil,
          model: computer.model,
          owned: computer.purchase_date...computer.disposal_date,
          uses: uses,
          specs: [],
          photo: computer.photo
        }
      end
      computer_details.sort_by!{|c| c[:owned].begin}
      next {category: category, items: computer_details}
    end
    groupings.sort_by!{|g| g[:category]}
    return groupings
  end

  def group_parts_by_category(parts)
    if @single_category
      parts = parts.includes(:part_use_periods)
      groupings = [{category: nil, items: part_details(parts)}]
    else
      parts = parts.includes(:part_categories, :part_use_periods, :computers)
      category_ids = parts.joins(:part_categories).map{|p| p.part_categories.pluck(:id)}.flatten.uniq
      categories = Array(PartCategory.where(id: category_ids))
      if @category_order
        lookup = @category_order.to_enum.with_index.to_h
        categories.sort_by!{|c| [lookup[c.slug] || lookup.size, c.name]}
      else
        categories.sort_by!{|c| c.name}
      end
      groupings = categories.map do |category|
        category_parts = Array(parts).uniq.select{|p|
          p.part_categories.include?(category)
        }
        category_name = category.name_category_heading(category_parts.size)
        next {category: category_name, items: part_details(category_parts)}
      end
    end
    return groupings
  end

  # Returns a hash of part details from an array of Parts
  def part_details(parts)
    part_details = parts.map do |part|
      uses = part.part_use_periods.map do |u|
        other_computer = @comparison_computer && u.computer != @comparison_computer
        next [u.start_date...u.end_date, {other_computer: other_computer}]
      end.to_h
      next {
        id: "part-#{part.id}",
        name: part.name.present? ? part.name : nil,
        model: part.model,
        owned: part.purchase_date...part.disposal_date,
        uses: uses,
        specs: part.specs_array,
        photo: part.photo
      }
    end
    part_details.sort_by!{|p| p[:owned].begin}
    return part_details
  end

  # Determines Computer use periods by merging overlapping PartUsePeriods for
  # the Computer's Parts.
  def merge_overlapping_part_use_periods(use_periods)
    date_ranges = use_periods.map{|u| u.start_date...u.end_date}.uniq
    merged = date_ranges.sort_by(&:begin).inject([]) do |ranges, range|
      if ranges.any? && use_period_ranges_overlap?(ranges.last, range)
        next ranges[0...-1] + [merge_use_period_ranges(ranges.last, range)]
      else
        next ranges + [range]
      end
    end
  end

  # Merges two overlapping PartUsePeriod date ranges into a single date range.
  def merge_use_period_ranges(a, b)
    ends = [a.end, b.end]
    max_end = ends.include?(nil) ? nil : ends.max
    return [a.begin, b.begin].min...max_end
  end

  # Checks if two PartUsePeriod date ranges overlap.
  def use_period_ranges_overlap?(a, b)
    return true if a.end.nil? && b.end.nil?
    a_includes_b_begin = a.end.nil? ? (b.end > a.begin) : a.include?(b.begin)
    b_includes_a_begin = b.end.nil? ? (a.end > b.begin) : b.include?(a.begin)
    return a_includes_b_begin || b_includes_a_begin
  end

end