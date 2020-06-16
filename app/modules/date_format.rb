# Provides utilities for formatting dates.
module DateFormat
  
  def self.text(input_date)
    input_date.strftime("%e %b %Y").strip
  end

  def self.electronics_owned_range_text(date_range)
    format = "%b %Y"
    if date_range.end.present?
      return [date_range.begin, date_range.end].map{|d| d.strftime(format)}.join(" – ")
    else
      return "Since #{date_range.begin.strftime(format)}"
    end
  end

  def self.range_text(input_date_range)
    return nil unless input_date_range.respond_to? :begin

    start = input_date_range.begin
    stop  = input_date_range.end
    
    if start.year == stop.year
      if start.month == stop.month
        return "#{start.strftime("%-d")}–#{stop.strftime("%-d %b %Y")}"
      else
        return "#{start.strftime("%-d %b")}–#{stop.strftime("%-d %b %Y")}"
      end
    else
      return "#{start.strftime("%-d %b %Y")}–#{stop.strftime("%-d %b %Y")}"
    end
  end

  def self.range_text(input_date_range)
    return nil unless input_date_range.respond_to? :begin

    start = input_date_range.begin
    stop  = input_date_range.end
    
    if start.year == stop.year
      if start.month == stop.month
        return "#{start.strftime("%-d")}–#{stop.strftime("%-d %b %Y")}"
      else
        return "#{start.strftime("%-d %b")}–#{stop.strftime("%-d %b %Y")}"
      end
    else
      return "#{start.strftime("%-d %b %Y")}–#{stop.strftime("%-d %b %Y")}"
    end
  end

  def self.range_text_without_year(input_date_range)
    return nil unless input_date_range.respond_to? :begin

    start = input_date_range.begin
    stop  = input_date_range.end
    
    if start.year == stop.year && start.month == stop.month
      return "#{start.strftime("%-d")}–#{stop.strftime("%-d %b")}"
    else
      return "#{start.strftime("%-d %b")}–#{stop.strftime("%-d %b")}"
    end
  end
  
end