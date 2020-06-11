# Describes a PAX Event
class PAXEvent
  def initialize(event, location, start_date, end_date)
    @event      = event
    @location   = location
    @start_date = start_date
    @end_date   = end_date
    @year       = start_date.year
  end

  # Returns the event date range as a string, shortened to remove years and duplicate months
  def dates
    return DateFormat::range_text_without_year(@start_date..@end_date)
  end

  # Returns the event name
  def event
    return @event
  end

  # Returns the event location
  def location
    return @location
  end

  # Returns a paramaterized name of the event
  def parameterized_name
    name = ["pax"]
    name.push @event.downcase unless @event.blank?
    name.push @year
    return name.join("-")
  end

  # Returns the name of the event without the word "PAX"
  def short_name
    name = Array.new
    name.push @event unless @event.blank?
    name.push @year
    return name.join(" ")
  end

  # Determines the theme of the event based on the event
  def theme
    themes = {
      ""          => "pax-west",
      "Prime"     => "pax-west",
      "West"      => "pax-west",
      "East"      => "pax-east",
      "South"     => "pax-south",
      "Aus"       => "pax-aus",
      "Unplugged" => "pax-unplugged",
      "Dev"       => "pax-dev"
    }
    return themes[@event]
  end

  # Returns the year of the event
  def year
    return @year
  end

end