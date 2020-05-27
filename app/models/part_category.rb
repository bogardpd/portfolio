class PartCategory < ApplicationRecord
  has_and_belongs_to_many :parts

  validates :name, presence: true
  after_validation :generate_slug

  # An array of slugs to define the default category order for parts tables.
  TABLE_ORDER = %w(processors motherboards displays video-cards memory storage optical-drives power-supplies cases wi-fi-adapters webcams operating-systems)

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

  # Returns a sort lookup hash with slugs as keys and integers as values. Used
  # to sort categories within parts tables.
  def self.table_order
    return TABLE_ORDER.to_enum.with_index.to_h
  end

  private

  # Generate a unique slug.
  def generate_slug
    self.slug = Slug.generate(Computer, self.name, self.name_was, self.slug_was)
  end  

end
