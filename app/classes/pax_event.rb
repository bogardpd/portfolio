# Describes a PAX Event
class PAXEvent
  def initialize(event, location, start_date, end_date)
    @event = event
    @year = start_date.year
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