class Computer < ApplicationRecord

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

end
