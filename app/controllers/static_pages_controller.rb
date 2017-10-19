class StaticPagesController < ApplicationController
  
  def home
  end
  
  def about
  end
  
  def boarding_pass_parser
  end
  
  def cad_models
  end
  
  def computers
  end
  
  def earthbound_database
  end
  
  def fast_track_calculus
  end
  
  def flight_historian
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
      render "static_pages/flight_historian/v#{params[:version]}"
      # TODO: redirect if page doesn't exist
    else
      @version_menu[:Overview][:active] = true
      render "static_pages/flight_historian/flight_historian"
    end
  end
  
  def fred_and_harry
  end
  
  def gallery
    gallery_template = "static_pages/galleries/#{params[:gallery]}/index"
    @page = (params[:page] || 1).to_i
    if template_exists?(gallery_template)
      render :template => gallery_template
    else
      raise ActionController::RoutingError.new("Not Found")
    end
  end
  
  def gps_logging
    @sources = {"garmin" => "Garmin", "ios" => "iOS"}
    @maps = {"google-earth" => "Google Earth", "osm" => "OpenStreetMap"}
    if @sources.keys.include?(params[:source]) && @maps.keys.include?(params[:map])
      render "static_pages/gps_logging/tutorial"
    else
      render "static_pages/gps_logging/gps_logging"
    end
  end
  
  def history
  end
  
  def hotel_internet_quality
  end
  
  def hotel_pillow_fort
  end
  
  def ingress_mosaics
  end
  
  def letsencrypt
    render text: ENV["LETS_ENCRYPT_KEY"]
  end
  
  def old_computers
    @computers = JSON.parse(File.read('app/assets/json/old-computers.json'))
  end
  
  def oreo
  end
  
  def pax
  end
  
  def reading_list
  end
  
  def resume
  end
  
  def shared_itinerary
  end
  
  def starmen_conventions
  end
  
  def stephenvlog
    @vlogs = Array.new
  end
  
  def terminal_silhouettes
    @ts_root = PortfolioImage::ROOT_PATH + "projects/terminal-silhouettes"
    
    @terminals = Hash.new()
    @terminals["ABI"] = "Abilene"
    @terminals["AMA"] = "Amarillo"
    @terminals["ATL"] = "Atlanta"
    @terminals["AVP"] = "Wilkes Barre/Scranton"
    @terminals["BFL"] = "Bakersfield"
    @terminals["BOS"] = "Boston"
    @terminals["BWI"] = "Baltimore"
    @terminals["BUR"] = "Burbank"
    @terminals["CDG"] = "Paris (Charles de Gaulle)"  
    @terminals["CHS"] = "Charleston, SC"  
    @terminals["CLE"] = "Cleveland"
    @terminals["CLT"] = "Charlotte"
    @terminals["CMH"] = "Columbus, OH"
    @terminals["CVG"] = "Cincinnati"
    @terminals["DAY"] = "Dayton"
    @terminals["DCA"] = "Washington (Reagan National)"
    @terminals["DEN"] = "Denver"
    @terminals["DSM"] = "Des Moines"
    @terminals["DFW"] = "Dallas/Fort Worth"
    @terminals["DTW"] = "Detroit"
    @terminals["EWR"] = "Newark"
    @terminals["FLG"] = "Flagstaff"
    @terminals["FRA"] = "Frankfurt"
    @terminals["GRK"] = "Killeen/Fort Hood"
    @terminals["HNL"] = "Honolulu"
    @terminals["IAD"] = "Washington (Dulles)"
    @terminals["IAH"] = "Houston (Bush)"
    @terminals["ICT"] = "Wichita"
    @terminals["IND"] = "Indianapolis"
    @terminals["ITO"] = "Hilo"
    @terminals["KEF"] = "Reykjavík (Keflavík)"
    @terminals["LAW"] = "Lawton"
    @terminals["LAX"] = "Los Angeles"
    @terminals["LGA"] = "New York (LaGuardia)"
    @terminals["LHR"] = "London (Heathrow)"
    @terminals["LIT"] = "Little Rock"
    @terminals["MCO"] = "Orlando (International)"
    @terminals["MDW"] = "Chicago (Midway)"
    @terminals["MHT"] = "Manchester, NH"
    @terminals["MKE"] = "Milwaukee"
    @terminals["MSP"] = "Minneapolis/St. Paul"
    @terminals["MUC"] = "Munich"
    @terminals["NUE"] = "Nuremberg"
    @terminals["OKC"] = "Oklahoma City"
    @terminals["OAJ"] = "Jacksonville, NC"
    @terminals["ONT"] = "Ontario"
    @terminals["ORD"] = "Chicago (O’Hare)"
    @terminals["PDX"] = "Portland, OR"
    @terminals["PHF"] = "Newport News/Williamsburg"
    @terminals["PHX"] = "Phoenix"
    @terminals["PIA"] = "Peoria"
    @terminals["PWM"] = "Portland, ME"
    @terminals["RAP"] = "Rapid City"
    @terminals["RDU"] = "Raleigh–Durham"
    @terminals["SAN"] = "San Diego"
    @terminals["SAT"] = "San Antonio"
    @terminals["SAV"] = "Savannah"
    @terminals["SEA"] = "Seattle/Tacoma"
    @terminals["SFO"] = "San Francisco"
    @terminals["SLC"] = "Salt Lake City"
    @terminals["STL"] = "St. Louis"
    @terminals["SPS"] = "Wichita Falls"
    @terminals["TUL"] = "Tulsa"
    @terminals["TPA"] = "Tampa"
    @terminals["TOL"] = "Toledo"
    @terminals["TUS"] = "Tucson"
    @terminals["TXL"] = "Berlin (Tegel)"
    @terminals["VPS"] = "Destin/Fort Walton Beach"
    @terminals["YYZ"] = "Toronto (Pearson)"
    
    @terminals = @terminals.sort_by { |iata, name| name }
    
  end
  
  def time_zone_chart
  end
  
  def turn_signal_counter
  end
  
  def visor_cam
  end

end