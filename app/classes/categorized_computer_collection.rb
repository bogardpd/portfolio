# Holds a collection of all Computers acting like Parts. Used to create a
# timeline for all computers.
class CategorizedComputerCollection < CategorizedPartCollection

  # Initializes a CategorizedPartCollection.
  def initialize
    @comparison_computer = nil
    @computers = Computer.all.includes(:part_use_periods)

    @groupings = group_computers_by_form_factor
    @parts = Array(@computers)
  end
  
  private

  # Creates a CategorizedPartCollection-like object, but with form factors as
  # PartCategories and computers as Parts.
  def group_computers_by_form_factor
    form_factor_groups = @computers.group_by{|c| c.form_factor}
    grouped_categories = Hash.new()
    Computer::FORM_FACTORS.each do |form_factor, name|
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
    return grouped_categories
  end

  # Determines Computer use periods by merging overlapping PartUsePeriods for
  # the Computer's Parts.
  def merge_overlapping_part_use_periods(use_periods)
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