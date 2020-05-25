class PartCategory < ApplicationRecord
  has_and_belongs_to_many :parts

  before_validation :generate_slug
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: {case_sensitive: false}

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

  protected

  # Generate a unique slug.
  def generate_slug
    self.slug = Slug.generate(Computer, self.name, self.name_was)
  end  

end
