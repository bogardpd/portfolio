# Holds a collection of Parts, grouped by their PartCategories. If a part has
# multiple categories, it will show up under each category.
class CategorizedPartCollection

  # Initializes a CategorizedPartCollection.
  # @param parts_association [Part::ActiveRecord_Associations_CollectionProxy]
  #   a collection of Parts
  # @param category_order [Array] an array of PartCategory slug strings
  #   specifying the order in which to sort the categories. PartCategories not
  #   in the array will be placed after the specified category and sorted
  #   alphabetically by name. If sort_order is not provided, all categories
  #   will be sorted alphabetically by name.
  # @param single_category [Boolean] if true, all parts will be grouped under
  #   a single nil category.
  # @param computer [Computer] the Computer all of the parts belong to, if any.
  #   Used for Computer timelines to decorate PartUsePeriod bars associated with
  #   this computer versus uses of the same Part in other computers.
  def initialize(parts_association, category_order: nil, single_category: false, computer: nil)
    @parts_association = parts_association.includes(:part_use_periods)
    if computer
      @parts_association = @parts_association.includes(:computers)
    end
    @comparison_computer = computer
    @category_order = category_order
    @single_category = single_category
    @parts = Array(@parts_association)

    @groupings = group_by_category
  end

  # Returns an array of all parts
  def all_parts
    return @parts
  end

  # Returns false if there are zero parts in the collection.
  def any_parts?
    return @parts.any?
  end

  # Returns the computer that all the collection parts belong to, if defined.
  def comparison_computer
    return @comparison_computer
  end

  # Returns the range between the minimum purchase date and maximum
  # disposal date.
  def date_range
    return nil unless @parts.any?
    min = @parts.min_by{|p| p.purchase_date}.purchase_date
    if @parts.any?{|p| p.disposal_date.nil?}
      max = nil
    else
      max = @parts.max_by{|p| p.disposal_date}.disposal_date
    end
    return (min...max)
  end

  # Returns a hash with PartCategories as keys and arrays of Parts as values.
  def groupings
    return @groupings
  end

  # Returns an ElectronicsTimeline for this instance's data.
  def timeline(include_tooltip_divs: true)
    et = ElectronicsTimeline.new(self)
    output = et.svg_xml
    if include_tooltip_divs
      output += et.tooltip_divs
    end
    return output.html_safe
  end

  private

  def group_by_category
    if @single_category
      return {nil => @parts}
    else
      parts = @parts_association.includes(:part_categories)
      category_ids = parts.joins(:part_categories).map{|p| p.part_categories.pluck(:id)}.flatten.uniq
      categories = Array(PartCategory.where(id: category_ids))

      if @category_order
        lookup = @category_order.to_enum.with_index.to_h
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
  end

end