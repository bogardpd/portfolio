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
      "1.0": {active: false},
      "1.1": {active: false},
      "1.2": {active: false},
      "1.3": {active: false},
      "2.0": {active: false},
      "2.1": {active: false}
    }
    if params[:version]
      @version_menu[params[:version].gsub("-",".").to_sym][:active] = true
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
  end
  
  def gps_logging_garmin_google_earth
  end
  
  def gps_logging_garmin_osm
  end
  
  def gps_logging_ios_google_earth
  end
  
  def gps_logging_ios_osm
  end
  
  def history
  end
  
  def hotel_internet_quality
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
    @terminals = Hash.new()
    @terminals['ABI'] = "Abilene"
    @terminals['AMA'] = "Amarillo"
    @terminals['ATL'] = "Atlanta"
    @terminals['BOS'] = "Boston"
    @terminals['BWI'] = "Baltimore"
    @terminals['BUR'] = "Burbank"
    @terminals['CDG'] = "Paris (Charles de Gaulle)"  
    @terminals['CHS'] = "Charleston, SC"  
    @terminals['CLT'] = "Charlotte"
    @terminals['CMH'] = "Columbus, OH"
    @terminals['CVG'] = "Cincinnati"
    @terminals['DAY'] = "Dayton"
    @terminals['DEN'] = "Denver"
    @terminals['DSM'] = "Des Moines"
    @terminals['DFW'] = "Dallas/Fort Worth"
    @terminals['EWR'] = "Newark"
    @terminals['HNL'] = "Honolulu"
    @terminals['IAD'] = "Washington (Dulles)"
    @terminals['ICT'] = "Wichita"
    @terminals['IND'] = "Indianapolis"
    @terminals['ITO'] = "Hilo"
    @terminals['KEF'] = "Reykjavík (Keflavík)"
    @terminals['LAX'] = "Los Angeles"
    @terminals['LGA'] = "New York (LaGuardia)"
    @terminals['LHR'] = "London (Heathrow)"
    @terminals['LIT'] = "Little Rock"
    @terminals['MCO'] = "Orlando (International)"
    @terminals['MDW'] = "Chicago (Midway)"
    @terminals['MHT'] = "Manchester, NH"
    @terminals['MKE'] = "Milwaukee"
    @terminals['MUC'] = "Munich"
    @terminals['NUE'] = "Nuremberg"
    @terminals['OKC'] = "Oklahoma City"
    @terminals['OAJ'] = "Jacksonville, NC"
    @terminals['ONT'] = "Ontario"
    @terminals['ORD'] = "Chicago (O’Hare)"
    @terminals['PDX'] = "Portland, OR"
    @terminals['PHX'] = "Phoenix"
    @terminals['PWM'] = "Portland, ME"
    @terminals['RAP'] = "Rapid City"
    @terminals['RDU'] = "Raleigh–Durham"
    @terminals['SAN'] = "San Diego"
    @terminals['SAT'] = "San Antonio"
    @terminals['SAV'] = "Savannah"
    @terminals['SEA'] = "Seattle/Tacoma"
    @terminals['SFO'] = "San Francisco"
    @terminals['SLC'] = "Salt Lake City"
    @terminals['STL'] = "St. Louis"
    @terminals['TUL'] = "Tulsa"
    @terminals['TUS'] = "Tucson"
    @terminals['TXL'] = "Berlin (Tegel)"
    @terminals['VPS'] = "Destin/Fort Walton Beach"
    @terminals['YYZ'] = "Toronto (Pearson)"
    
    @terminals = @terminals.sort_by { |iata, name| name }
  end
  
  def time_zone_chart
  end
  
  def turn_signal_counter
  end
  
  def visor_cam
  end

end