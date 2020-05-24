class Computer < ApplicationRecord
  FORM_FACTORS = {laptop: "Laptop", desktop: "Desktop"}

  before_validation :generate_slug
  validates :name, presence: true
  validates :form_factor, inclusion: {in: FORM_FACTORS.keys.map(&:to_s), message: "%{value} is not a valid form factor."}
  validates :purchase_date, presence: true
  validates :slug, uniqueness: true

  # Override to_param so forms use slugs
  def to_param
    return slug
  end

  # # Returns all computer parts currently in use (with a nil final end date),
  # # grouped by part type.
  # def current_parts_by_category
  #   return @parts.computer_parts_today
  # end

  # # Formats a type name to singular or plural based on the count of parts
  # def part_category_name(part_type, count)
  #   return nil unless part_type && count
  #   if count == 1
  #     return nil unless details = @parts.part_types[part_type]
  #     return details[:singular] || details[:name].singularize
  #   else
  #     return @parts.part_types.dig(part_type, :name)
  #   end
  # end

  protected

  def generate_slug
    slug = self.name.parameterize
    if self.name_was != slug
      existing = Computer.where("slug LIKE :prefix", prefix: "##{slug}").pluck(:slug) && ["new"]
      if existing.include?(slug)
        numbered_matching_slugs = existing.select{|e| e[/^#{slug}-\d+/]}
        if numbered_matching_slugs.any?
          numbers = numbered_matching_slugs.map{|s| s.rpartition("-").last.to_i}
          self.slug = "#{slug}-#{numbers.max + 1}"
        else
          self.slug = "#{slug}-1"
        end
      else
        self.slug = slug
      end
    end
  end  

end
