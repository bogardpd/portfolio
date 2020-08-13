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
    pax = PAXEvent.new(*YAML.load_file("app/data/paxen.yml")[params[:gallery]].values)
    gallery_template(title: pax.short_name, path: pax_gallery_path(gallery: params[:gallery]))
  end
  
  def gallery_starmen
    add_breadcrumb "Starmen.Net Conventions", starmen_conventions_path
    @convention = YAML.load_file("app/data/starmen_conventions.yml")[params[:gallery]].symbolize_keys
    @meta_description = "Photos from #{@convention[:name]} (#{DateFormat.range_text(@convention[:start]..@convention[:end])})"
    gallery_template(title: @convention[:name], path: starmen_con_gallery_path(gallery: params[:gallery]))
  end

  def games
    add_breadcrumb "Games", games_path
  end

  def gate_13
    add_breadcrumb "Gate 13", gate_13_path
  end
  
  def gps_logging
    add_breadcrumb "GPS Logging", gps_logging_path
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

  def idea_guy
    add_breadcrumb "Games", games_path
    add_breadcrumb "Idea Guy Game Generator", idea_guy_path
    @ideas = YAML.load_file("app/data/idea_guy.yml").shuffle
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
  
  def oreo
    add_breadcrumb "Oreo", oreo_path
  end
  
  def pax
    add_breadcrumb "PAX", pax_path
    @paxen = YAML.load_file("app/data/paxen.yml").values.map{|pax| PAXEvent.new(*pax.values)}
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
    @conventions = YAML.load_file("app/data/starmen_conventions.yml").deep_symbolize_keys
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

end