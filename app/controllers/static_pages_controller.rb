class StaticPagesController < ApplicationController
  
  def projects
    # Home page directs here

    if params[:tag]
      @projects = Project.all.select{|k, v| v[:tags].include?(params[:tag])}
    else
      @projects = Project.all
    end
    
    @tag = params[:tag] ? Project.all_tags[params[:tag].to_sym] : nil
    @tags = {nil => {name: "All Projects", description: "All Projects"}}.merge(Project.all_tags)

  end
  
  def about
    add_breadcrumb "About", about_path
  end
  
  def airport_code_puns
    add_breadcrumb "Airport Code Puns", airport_code_puns_path
    @puns = YAML.load_file("app/data/airport_code_puns.yml").deep_symbolize_keys.sort.to_h
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
    @all_versions = YAML.load_file("app/data/flight_historian_versions.yml").deep_symbolize_keys
    version_key = params[:version]&.to_sym
    unless @all_versions[version_key]
      redirect_to flight_historian_path
      return
    end
    @version = @all_versions[version_key]
    if params[:version]
      add_breadcrumb "Version #{@version[:version]}", flight_historian_path(version: version_key)
      render "static_pages/flight_historian/v#{version_key}"
    else
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