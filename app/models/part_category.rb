class PartCategory < ApplicationRecord
  has_and_belongs_to_many :parts

  before_validation :generate_slug
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: {case_sensitive: false}

  protected

  def generate_slug
    self.slug = Slug.generate(Computer, self.name, self.name_was)
  end  

end
