class StaticPagesController < ApplicationController
  
  def home
  end
  
  def about
    add_breadcrumb "About", about_path
  end
  
  def airport_code_puns
    add_breadcrumb "Airport Code Puns", airport_code_puns_path
    @puns = [
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
        ["To the coa<code>STL</code>ines and beyond", "Jeff"]
      ]]
    ]
  end
  
  def boarding_pass_parser
    add_breadcrumb "Boarding Pass Parser", boarding_pass_parser_path
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
    pax_galleries = {
      "pax-prime-2010" => "PAX Prime 2010",
      "pax-prime-2011" => "PAX Prime 2011",
      "pax-prime-2012" => "PAX Prime 2012",
      "pax-east-2013" => "PAX East 2013",
      "pax-prime-2013" => "PAX Prime 2013",
      "pax-east-2014" => "PAX East 2014",
      "pax-east-2015" => "PAX East 2015",
      "pax-west-2017" => "PAX West 2017"
    }
    gallery_template(title: pax_galleries[params[:gallery]], path: pax_gallery_path(gallery: params[:gallery]))
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
  
  def letsencrypt
    render text: ENV["LETS_ENCRYPT_KEY"]
  end
  
  def maps
    add_breadcrumb "Maps", maps_path
    maps = Hash.new
    maps["interstate-grid"]   = "Interstate Grid"
    maps["nashville-hex"]     = "Nashville Hex"
    maps["pax-west-area-map"] = "PAX West Area Map"
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
    @photos = [
      {filename: "2015-07-16-a.jpg", date: Date.parse("2015-07-16"), people: "Paul", event: "Work Trip (the photo that started it all)"},
      {filename: "2015-07-16-b.jpg", date: Date.parse("2015-07-16"), people: "Vid", event: "Camp Fangamer 2015"},
      {filename: "2015-08-25.jpg", date: Date.parse("2015-08-25"), people: "Vid", event: "PAX West 2015"},
      {filename: "2016-07-28.jpg", date: Date.parse("2016-07-28"), people: "Vid", event: "Camp Fangamer 2016"},
      {filename: "2016-08-30.jpg", date: Date.parse("2016-08-30"), people: "Vid", event: "PAX West 2016"},
      {filename: "2016-12-25.jpg", date: Date.parse("2016-12-25"), people: "Vid", event: "Portland Christmas 2016"},
      {filename: "2017-01-24.jpg", date: Date.parse("2017-01-24"), people: "Paul", event: "Work Trip"},
      {filename: "2017-08-25.jpg", date: Date.parse("2017-08-25"), people: "Vid", event: "PAX West 2017"},
      {filename: "2017-10-03.jpg", date: Date.parse("2017-10-03"), people: "Paul", event: "Disney Vacation"},
      {filename: "2017-11-21.jpg", date: Date.parse("2017-11-21"), people: "Vid", event: "PAX Unplugged 2017"},
      {filename: "2017-12-30.jpg", date: Date.parse("2017-12-30"), people: "Vid", event: "MAGFest 2018"},
      {filename: "2018-07-16.jpg", date: Date.parse("2018-07-16"), people: "Vid", event: "Camp Fangamer 2018"},
      {filename: "2018-07-23-a.jpg", date: Date.parse("2018-07-23"), people: "Karen", event: "Camp Fangamer 2018"},
      {filename: "2018-07-23-b.jpg", date: Date.parse("2018-07-23"), people: "Karen and Vid", event: "Camp Fangamer 2018"},
      {filename: "2018-07-23-c.jpg", date: Date.parse("2018-07-23"), people: "Karen and Vid", event: "Camp Fangamer 2018"}
    ]
  end
  
  def old_computers
    add_breadcrumb "Computers", computers_path
    add_breadcrumb "Old Computers", old_computers_path
    @computers = JSON.parse(File.read('app/assets/json/old-computers.json'))
  end
  
  def oreo
    add_breadcrumb "Oreo", oreo_path
  end
  
  def pax
    add_breadcrumb "PAX", pax_path
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
  
  def starmen_conventions
    add_breadcrumb "Starmen.Net Conventions", starmen_conventions_path
  end
  
  def stephenvlog
    add_breadcrumb "StephenVlog", stephenvlog_path
    @vlogs = Array.new
  end
  
  def time_zone_chart
    add_breadcrumb "Time Zone Chart", time_zone_chart_path
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