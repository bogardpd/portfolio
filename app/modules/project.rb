module Project
  
  LIST = [
      {
        name: "Flight Historian",
        caption: "A flight history tracking application",
        tags: %w(databases programming ruby-on-rails)
      },
      {
        name: "Terminal Silhouettes",
        caption: "Airport art",
        tags: %w(illustrations svg)
      },
      {
        name: "Shared Itinerary",
        caption: "Flight time charts for multiple travelers",
        tags: %w(databases programming ruby-on-rails svg)
      },
      {
        name: "Flight Directed Graphs",
        caption: "Airport relationship diagrams",
        tags: %w(graphs programming ruby-on-rails)
      },
      {
        name: "Boarding Pass Parser",
        caption: "Barcode data parsing",
        tags: %w(programming ruby-on-rails)
      },
      {
        name: "Time Zone Chart",
        caption: "Plotter for time zone changes",
        tags: %w(javascript jquery programming svg)
      },
      {
        name: "Gate 13",
        caption: "Unlucky airport gates",
        tags: %w(maps qgis)
      },
      {
        name: "Nights Away and Home",
        caption: "Travel duration chart",
        tags: %w(charts programming python svg)
      },
      {
        name: "Travel Heatmap",
        caption: "Time spent in various cities",
        tags: %w(maps qgis)
      },
      {
        name: "PAX West Area Map",
        caption: "Map of convention venues and hotels",
        tags: %w(maps qgis svg)
      },
      {
        name: "Interstate Grid",
        caption: "Intersections of major US interstates",
        tags: %w(illustrations maps svg)
      },
      {
        name: "Nashville Hex",
        caption: "Nashville’s freeways on a hex grid",
        tags: %w(illustrations maps svg)
      },
      {
        name: "GPS Logging",
        caption: "Maps of travel paths",
        tags: %w(maps)
      },
      {
        name: "Turn Signal Counter",
        caption: "Counter integrated circuits on a truck",
        tags: %w(electronics)
      },
      {
        name: "CAD Models",
        caption: "3D sketches",
        tags: %w(cad illustrations)
      },
      {
        name: "EarthBound Database",
        caption: "A game information repository",
        tags: %w(databases php programming)
      },
      {
        name: "Visor Cam",
        caption: "Road trip time lapse videos",
        tags: %w(video)
      },
      {
        name: "Hotel Internet Quality",
        caption: "Plots of hotel bandwidth by time of day",
        tags: %w(charts)
      }
    ]

  TAGS = {
    "cad": {
      name: "CAD",
      description: "Computer-aided design drawings"
    },
    "charts": {
      name: "Charts",
      description: "Illustrations of data"
    },
    "databases": {
      name: "Databases",
      description: "Projects whose primary purpose involves a database"
    },
    "electronics": {
      name: "Electronics",
      description: "Projects involving circuit design"
    },
    "graphs": {
      name: "Graphs",
      description: "Representations of relationships as nodes and edges"
    },
    "illustrations": {
      name: "Illustrations",
      description: "Visual art"
    },
    "javascript": {
      name: "JavaScript",
      description: "Projects making extensive use of the JavaScript language"
    },
    "jquery": {
      name: "jQuery",
      description: "Projects using the jQuery JavaScript library"
    },
    "maps": {
      name: "Maps",
      description: "Geospatial art and data"
    },
    "php": {
      name: "PHP",
      description: "Projects using the PHP language"
    },
    "programming": {
      name: "Programming",
      description: "Programming projects"
    },
    "python": {
      name: "Python",
      description: "Projects using the Python language"
    },
    "qgis": {
      name: "QGIS",
      description: "Maps created with QGIS"
    },
    "ruby-on-rails": {
      name: "Ruby on Rails",
      description: "Projects using the Ruby on Rails web framework"
    },
    "svg": {
      name: "SVG",
      description: "Projects using Scalable Vector Graphics images"
    },
    "video": {
      name: "Video",
      description: "Video projects"
    }
  }
  
  def self.path(name)
    return "#{name.parameterize.underscore}_path"
  end
  
end