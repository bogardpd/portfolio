class Book < ActiveRecord::Base
  validates :title, presence: true
  validates :author, presence: true
  
  # Returns a link to the book on the Amazon Kindle store, or nil if there is no link.
  def amazon_link
    self.amazon_id.present? ? "https://www.amazon.com/gp/product/#{self.amazon_id}" : nil
  end
  
end
