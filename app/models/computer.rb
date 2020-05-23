class Computer < ApplicationRecord
  FORM_FACTORS = {laptop: "Laptop", desktop: "Desktop"}

  validates :name, presence: true
  validates :form_factor, inclusion: {in: FORM_FACTORS.keys.map(&:to_s), message: "%{value} is not a valid form factor."}
  validates :purchase_date, presence: true
  before_save :generate_slug

  # # Returns an array of description paragraphs. If the computer has no
  # # description, returns an empty array.
  # def description
  #   return @computer[:description] || []
  # end

  # # Returns the computer's form factor.
  # def form_factor
  #   return @computer[:form_factor]
  # end

  # # Returns the computer's model.
  # def model
  #   return @computer[:model]
  # end

  # # Returns the relative path to the computer's photo.
  # def photo
  #   return @computer[:photo]
  # end

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

  # def self.slug(str)
  #   existing = %w(peanut peanut-1 peanut-2 peanut-butter peanut-butter-1 fishsticks)
  #   slug = str.parameterize
  #   if existing.include?(slug)
  #     numbered_matching_slugs = existing.select{|e| e[/^#{slug}-\d+/]}
  #     if numbered_matching_slugs.any?
  #       numbers = numbered_matching_slugs.map{|s| s.rpartition("-").last.to_i}
  #       return "#{slug}-#{numbers.max + 1}"
  #     else
  #       return "#{slug}-1"
  #     end
  #   else
  #     return slug
  #   end
  # end

  protected

  def generate_slug
    slug = self.name.parameterize
    existing = Computer.where("slug LIKE :prefix", prefix: "##{slug}").pluck(:slug)
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
