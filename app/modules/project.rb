module Project
  
  LIST = [
      {name: "Flight Historian",       caption: "A flight history tracking application"},
      {name: "Shared Itinerary",       caption: "Flight time charts for multiple travelers"},
      {name: "Terminal Silhouettes",   caption: "Airport art"},
      {name: "Boarding Pass Parser",   caption: "Barcode data parsing"},
      {name: "GPS Logging",            caption: "Maps of travel paths"},
      {name: "Turn Signal Counter",    caption: "Counter integrated circuits on a truck"},
      {name: "CAD Models",             caption: "3D sketches"},
      {name: "EarthBound Database",    caption: "A game information repository"},
      {name: "Visor Cam",              caption: "Road trip time lapse videos"},
      {name: "Hotel Internet Quality", caption: "Plots of hotel bandwidth by time of day"}
    ]
  
  def self.path(name)
    "#{name.parameterize.underscore}_path"
  end
  
end