module FormattedDate
  
  def self.text(input_date)
    input_date.strftime("%e %b %Y").strip
  end
  
end