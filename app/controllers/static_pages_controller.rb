class StaticPagesController < ApplicationController
  
  def projects
    # Home page directs here

    if params[:tag]
      @projects = Project::LIST.select{|p| p[:tags].include?(params[:tag])}
    else
      @projects = Project::LIST
    end
    
    @tags = {nil => {name: "All Projects", description: "All Projects"}}.merge(Project::TAGS)

  end
  
  def about
    add_breadcrumb "About", about_path
  end
  
  def airport_code_puns
    add_breadcrumb "Airport Code Puns", airport_code_puns_path
    @puns = [
      ["AUS", "Austin", [
        ["No p<code>AUS</code>in ’til <code>AUS</code>tin", "Shawn Bianchi", "Photo taken at SJC"]
      ]],
      ["CVG", "Cincinnati", [
        ["<code>C</code>lean. <code>V</code>ery <code>G</code>reen."]
      ]],
      ["DAY", "Dayton", [
        ["It’s a great <code>DAY</code> to recycle!"],
        ["A better <code>DAY</code>, landing soon."],
        ["Every <code>DAY</code> can be something new."]
      ]],
      ["ORD", "Chicago (O’Hare)", [
        ["Extra<code>ORD</code>inary"]
      ]],
      ["STL", "St. Louis", [
        ["Every day we’re hu<code>STL</code>ing for you"],
        ["To the coa<code>STL</code>ines and beyond", "Jeff"],
        ["Bu<code>STL</code>ing"],
        ["It’s va<code>STL</code>y better than landfills"],
        ["Whi<code>STL</code>e while we work"],
        ["Don’t wre<code>STL</code>e your bags"],
        ["Feeling re<code>STL</code>ess"],
        ["Giving you more bells and whi<code>STL</code>es"],
        ["No more jo<code>STL</code>ing"]
      ]]
    ]
  end
  
  def boarding_pass_parser
    add_breadcrumb "Boarding Pass Parser", boarding_pass_parser_path
  end
  
  def books
    add_breadcrumb "Books", books_path
  end

  def cad_models
    add_breadcrumb "CAD Models", cad_models_path
  end
  
  def computers
    add_breadcrumb "Computers", computers_path
  end
  
  def earthbound_database
    add_breadcrumb "EBDB", earthbound_database_path
  end
  
  def fast_track_calculus
    add_breadcrumb "RHIT", rhit_path
    add_breadcrumb "Fast Track Calculus", fast_track_calculus_path
  end

  def flight_directed_graphs
    add_breadcrumb "Flight Directed Graphs", flight_directed_graphs_path
  end
  
  def flight_historian
    add_breadcrumb "Flight Historian", flight_historian_path
    @version_menu = {
      "Overview": {active: false},
      "1.0": {
        active: false,
        summary: {
          release_date: Date.parse("2013-04-27"),
          github_repo: "bogardpd/flight_log",
          specs: [
            "flight-historian/1.0/Flight Log 1.0 Functional Specification.pdf",
            "flight-historian/1.0/Flight Log 1.0 Technical Specification.pdf"
          ]
        }
      },
      "1.1": {
        active: false,
        summary: {
          release_date: Date.parse("2013-10-24"),
          github_repo: "bogardpd/flight_log",
          specs: [
            "flight-historian/1.1/Flight Log 1.1 Functional Specification.pdf",
            "flight-historian/1.1/Flight Log 1.1 Technical Specification.pdf"
          ]
        }
      },
      "1.2": {
        active: false,
        summary: {
          release_date: Date.parse("2014-10-27"),
          github_repo: "bogardpd/flight_log",
          specs: [
            "flight-historian/1.2/Flight Log 1.2 Functional Specification.pdf",
            "flight-historian/1.2/Flight Log 1.2 Technical Specification.pdf"
          ]
        }
      },
      "1.3": {
        active: false,
        summary: {
          release_date: Date.parse("2015-02-08"),
          github_repo: "bogardpd/flight_log",
          git_sha: "49798a2b120ffcfe1512b0f3576023469e961c1b",
          specs: [
            "flight-historian/1.3/Flight Log 1.3 Functional Specification.pdf",
            "flight-historian/1.3/Flight Log 1.3 Technical Specification.pdf"
          ]
        }
      },
      "2.0": {
        active: false,
        summary: {
          release_date: Date.parse("2016-01-31"),
          github_repo: "bogardpd/flight_log",
          git_sha: "d1a5f3da3e3d593f2b4c629f8ddfdcc0aefb820c",
          specs: [
            "flight-historian/2.0/Flight Historian 2.0 Functional Specification.pdf",
            "flight-historian/2.0/Flight Historian 2.0 Technical Specification.pdf"
          ]
        }
      },
      "2.1": {
        active: false,
        summary: {
          release_date: Date.parse("2017-04-29"),
          github_repo: "bogardpd/flight_log",
          git_sha: "f4ba7e0e279a5e27481e31374c1230f8e8d9e08b",
          specs: ["flight-historian/2.1/Flight Historian 2.1 Specification.pdf"]
        }
      },
      "2.2": {
        active: false,
        summary: {
          release_date: Date.parse("2018-03-15"),
          github_repo: "bogardpd/flight_log",
          git_sha: "5c7b7d4eb0b3ce6dcb973c471aa28b5a795bc87f",
          specs: ["flight-historian/2.2/Flight Historian 2.2 Specification.pdf"]
        }
      },
      "2.3": {
        active: false,
        summary: {
          release_date: Date.parse("2019-04-30"),
          github_repo: "bogardpd/flight_log",
          git_sha: "5bf329d66b383a88e005f32b0415d39cbe9f0916",
          specs: ["flight-historian/2.3/Flight Historian 2.3 Specification.pdf"]
        }
      }
    }
    version_sym = params[:version] ? params[:version].gsub("-",".").to_sym : nil
    if params[:version]
      unless @version_menu[version_sym]
        redirect_to flight_historian_path
        return
      end
      @version_menu[version_sym][:active] = true
      @summary = @version_menu[version_sym][:summary]
      add_breadcrumb "Version #{version_sym}", flight_historian_path(version: version_sym)
      render "static_pages/flight_historian/v#{params[:version]}"
      # TODO: redirect if page doesn't exist
    else
      @version_menu[:Overview][:active] = true
      render "static_pages/flight_historian/flight_historian"
    end
  end
  
  def fred_and_harry
    add_breadcrumb "RHIT", rhit_path
    add_breadcrumb "Fast Track Calculus", fast_track_calculus_path
    add_breadcrumb "Fred and Harry", fred_and_harry_path
  end
  
  def gallery_pax
    add_breadcrumb "PAX", pax_path
    title = paxen.find{|p| p.parameterized_name == params[:gallery]}&.short_name
    gallery_template(title: title, path: pax_gallery_path(gallery: params[:gallery]))
  end
  
  def gallery_starmen
    add_breadcrumb "Starmen.Net Conventions", starmen_conventions_path
    starmen_conventions = {
      "washingcon" => "Washingcon",
      "chicagocon" => "Chicagocon",
      "yes-we-con" => "Yes We Con",
      "gatlincon" => "Gatlincon",
      "utacon" => "Utacon",
      "flagstaff-con" => "Flagstaff Con",
      "indiana-minicon" => "Indiana Minicon",
      "applecon" => "Applecon",
      "camp-fangamer-2015" => "Camp Fangamer 2015",
      "camp-videogamely-2016" => "Camp Videogamely 2016",
      "camp-fangamer-2018" => "Camp Fangamer 2018"
    }
    gallery_template(title: starmen_conventions[params[:gallery]], path: starmen_con_gallery_path(gallery: params[:gallery]))
  end

  def games
    add_breadcrumb "Game Screen Names", games_path
  end

  def gate_13
    add_breadcrumb "Gate 13", gate_13_path
  end
  
  def gps_logging
    add_breadcrumb "GPS Logging", gps_logging_path
    @sources = {"garmin" => "Garmin", "ios" => "iOS"}
    @maps = {"google-earth" => "Google Earth", "osm" => "OpenStreetMap"}
    if @sources.keys.include?(params[:source]) && @maps.keys.include?(params[:map])
      add_breadcrumb "#{@sources[params[:source]]} and #{@maps[params[:map]]}", gps_logging_path(source: params[:source], map: params[:map])
      render "static_pages/gps_logging/tutorial"
    else
      render "static_pages/gps_logging/gps_logging"
    end
  end
  
  def history
    add_breadcrumb "Website History", history_path
  end
  
  def hotel_internet_quality
    add_breadcrumb "Hotel Internet Quality", hotel_internet_quality_path
  end
  
  def hotel_pillow_fort
    add_breadcrumb "Hotel Pillow Fort", hotel_pillow_fort_path
  end
  
  def ingress_mosaics
    add_breadcrumb "Ingress Mosaic Maps", ingress_mosaics_path
  end

  def interstate_grid
    add_breadcrumb "Interstate Grid", interstate_grid_path
  end
  
  def letsencrypt
    render plain: ENV["LETS_ENCRYPT_KEY"]
  end
  
  def maps
    add_breadcrumb "Maps", maps_path
    maps = Hash.new
    maps["gate-13"]           = "Gate 13"
    maps["interstate-grid"]   = "Interstate Grid"
    maps["nashville-hex"]     = "Nashville Hex"
    maps["pax-west-area-map"] = "PAX West Area Map"
    maps["travel-heatmap"]    = "Travel Heatmap"
    if params[:map].present?
      if maps[params[:map]]
        add_breadcrumb maps[params[:map]], maps_path(map: params[:map])
        render "static_pages/maps/#{params[:map].gsub("-","_")}"
      else
        redirect_to maps_path
      end
    else
      render "static_pages/maps/index"
    end
  end

  def mco_lobby
    add_breadcrumb "MCO Lobby", mco_lobby_path
    begin
      photo_index = "#{PortfolioImage::ROOT_PATH}mco-lobby/photos.json"
      response = Net::HTTP.get_response(URI.parse(photo_index))
      photos = JSON.parse(response.body.force_encoding("UTF-8"), {symbolize_names: true})
      @photos = photos.map{|photo| {
        filename: photo[:filename],
        date: Date.parse(photo[:date]).strftime("%-d %b %Y"),
        people: photo[:people],
        event: photo[:event]
        }}
    rescue
      @photos = Array.new
    end
  end

  def nashville_hex
    add_breadcrumb "Nashville Hex", nashville_hex_path
  end

  def nights_away_and_home
    add_breadcrumb "Nights Away and Home", nights_away_and_home_path
  end
  
  def old_computers
    add_breadcrumb "Computers", computers_path
    add_breadcrumb "Old Computers", old_computers_path
    @computers = JSON.parse(File.read('app/assets/json/old-computers.json'))
    @computers_hash = @computers.to_h.with_indifferent_access
  end
  
  def oreo
    add_breadcrumb "Oreo", oreo_path
  end
  
  def pax
    add_breadcrumb "PAX", pax_path
    @paxen = paxen
  end

  def pax_west_area_map
    add_breadcrumb "PAX West Area Map", pax_west_area_map_path
  end
  
  def resume
    add_breadcrumb "Résumé", resume_path
  end

  def rhit
    add_breadcrumb "RHIT", rhit_path
  end
  
  def shared_itinerary
    add_breadcrumb "Shared Itinerary", shared_itinerary_path
  end

  def song_lyrics_graph
    add_breadcrumb "Song Lyrics Graph", song_lyrics_graph_path
  end
  
  def starmen_conventions
    add_breadcrumb "Starmen.Net Conventions", starmen_conventions_path
  end
  
  def time_zone_chart
    add_breadcrumb "Time Zone Chart", time_zone_chart_path
  end
  
  def travel_heatmap
    add_breadcrumb "Travel Heatmap", travel_heatmap_path
  end
  
  def turn_signal_counter
    add_breadcrumb "Turn Signal Counter", turn_signal_counter_path
  end
  
  def visor_cam
    add_breadcrumb "Visor Cam", visor_cam_path
  end
  
  private
  
  def gallery_template(title: nil, path: nil)
    template = "static_pages/galleries/#{params[:gallery]}/index"
    title ||= params[:gallery]
    path ||= root_path
    @page = (params[:page] || 1).to_i
    if template_exists?(template)
      add_breadcrumb title, path
      render :template => template
    else
      raise ActionController::RoutingError.new("Not Found")
    end
  end

  def paxen
    p = Array.new
    p.push PAXEvent.new("Prime", "Seattle",     Date.parse("2010-09-03"), Date.parse("2010-09-05"))
    p.push PAXEvent.new("Prime", "Seattle",     Date.parse("2011-08-26"), Date.parse("2011-08-28"))
    p.push PAXEvent.new("Prime", "Seattle",     Date.parse("2012-08-31"), Date.parse("2012-09-02"))
    p.push PAXEvent.new("East",  "Boston",      Date.parse("2013-03-22"), Date.parse("2013-03-24"))
    p.push PAXEvent.new("Prime", "Seattle",     Date.parse("2013-08-30"), Date.parse("2013-09-02"))
    p.push PAXEvent.new("East",  "Boston",      Date.parse("2014-04-11"), Date.parse("2014-04-13"))
    p.push PAXEvent.new("East",  "Boston",      Date.parse("2015-03-06"), Date.parse("2015-03-08"))
    p.push PAXEvent.new("West",  "Seattle",     Date.parse("2017-09-01"), Date.parse("2017-09-04"))
    p.push PAXEvent.new("West",  "Seattle",     Date.parse("2018-08-31"), Date.parse("2018-09-03"))
    p.push PAXEvent.new("South", "San Antonio", Date.parse("2019-01-18"), Date.parse("2019-01-20"))
    return p
  end
end