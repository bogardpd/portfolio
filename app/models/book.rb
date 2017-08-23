class Book < ActiveRecord::Base
  validates :title, presence: true
  validates :author, presence: true
  validates :page_count, numericality: { only_integer: true }, allow_blank: true
  
  # Returns a link to the book on the Amazon Kindle store, or nil if there is no link.
  def amazon_link
    self.amazon_id.present? ? "https://www.amazon.com/gp/product/#{self.amazon_id}" : nil
  end
  
  # Returns a hash with years as the keys, and an array of books completed in each year as the values.
  def self.books_by_year
    books_by_year = Hash.new(nil)
    Book.where.not(completion_date: nil).order(completion_date: :desc).each do |book|
      books_by_year[book.completion_date.year] = Array.new if books_by_year[book.completion_date.year].nil?
      books_by_year[book.completion_date.year].push(book)
    end
    books_by_year
  end
  
  # Returns an array of books with no completion date.
  def self.currently_reading
    Book.where(completion_date: nil)
  end
end
