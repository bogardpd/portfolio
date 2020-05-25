module Slug

  RESERVED_SLUGS = %w(new)

  def self.generate(model, name, name_was, slug_was)
    return slug_was unless name && name.present?
    slug = name.parameterize
    if name_was&.parameterize != slug
      existing = model.where("slug LIKE :prefix", prefix: "#{slug}%").pluck(:slug) | RESERVED_SLUGS
      puts "existing: #{existing}"
      if existing.include?(slug)
        numbered_matching_slugs = existing.select{|e| e[/^#{slug}-\d+/]}
        if numbered_matching_slugs.any?
          numbers = numbered_matching_slugs.map{|s| s.rpartition("-").last.to_i}
          slug = "#{slug}-#{numbers.max + 1}"
        else
          slug = "#{slug}-1"
        end
      end
    end
    return slug
  end

end