class PartCategory < ApplicationRecord
  has_and_belongs_to_many :parts

  validates :name, presence: true
  after_validation :generate_slug

  scope :alphabetical, -> {order(:name)}
  scope :used_without_computer, -> {
    joins(parts: :part_use_periods)
      .where(parts: {part_use_periods: {computer: nil}})
      .alphabetical
      .distinct
  }

  # Override to_param so forms use slugs.
  def to_param
    return self.slug
  end

  # Returns the category name in lowercase plural format.
  def name_lowercase_plural
    if read_attribute(:name_lowercase_plural).present?
      return read_attribute(:name_lowercase_plural)
    else
      return read_attribute(:name)&.downcase
    end
  end

  # Returns a singular name if count == 1, plural name otherwise
  def name_category_heading(count)
    if count == 1
      return self.name_singular || self.name.singularize
    else
      return self.name
    end
  end

  # Returns the other PartCategories associated with any Part of this
  # PartCategory. Returns an empty Array if there are no other categories.
  def shared_categories
    categories = self.parts.includes(:part_categories).map{|p| p.part_categories}.flatten.uniq
    return categories.reject{|c| c == self}.sort_by(&:name)
  end

  private

  # Generate a unique slug.
  def generate_slug
    self.slug = Slug.generate(Computer, self.name, self.name_was, self.slug_was)
  end  

end
