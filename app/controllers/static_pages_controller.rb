class StaticPagesController < ApplicationController
  
  def home
  end
  
  def about
  end
  
  def cad_models
  end
  
  def computers
  end
  
  def earthbound_database
  end
  
  def flight_historian
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
  
  def hotel_internet_quality
  end
  
  def ingress_murals
  end
  
  def reading_list
  end
  
  def resume
  end
  
  def stephenvlog
    @vlogs = Array.new
  end
  
  def terminal_silhouettes
    @terminals = Hash.new()
    @terminals['ABI'] = "Abilene"
    @terminals['ATL'] = "Atlanta"
    @terminals['BOS'] = "Boston"
    @terminals['BWI'] = "Baltimore"
    @terminals['CHS'] = "Charleston, SC"  
    @terminals['CLT'] = "Charlotte"
    @terminals['CMH'] = "Columbus, OH"
    @terminals['CVG'] = "Cincinnati"
    @terminals['DAY'] = "Dayton"
    @terminals['DEN'] = "Denver"
    @terminals['DFW'] = "Dallas/Fort Worth"
    @terminals['EWR'] = "Newark"
    @terminals['HNL'] = "Honolulu"
    @terminals['IAD'] = "Washington (Dulles)"
    @terminals['ICT'] = "Wichita"
    @terminals['IND'] = "Indianapolis"
    @terminals['ITO'] = "Hilo"
    @terminals['LAX'] = "Los Angeles"
    @terminals['LGA'] = "New York (LaGuardia)"
    @terminals['LHR'] = "London (Heathrow)"
    @terminals['LIT'] = "Little Rock"
    @terminals['MCO'] = "Orlando (International)"
    @terminals['MDW'] = "Chicago (Midway)"
    @terminals['MHT'] = "Manchester, NH"
    @terminals['OKC'] = "Oklahoma City"
    @terminals['ORD'] = "Chicago (O’Hare)"
    @terminals['PDX'] = "Portland, OR"
    @terminals['PHX'] = "Phoenix"
    @terminals['SAV'] = "Savannah"
    @terminals['SEA'] = "Seattle/Tacoma"
    @terminals['SLC'] = "Salt Lake City"
    @terminals['STL'] = "St. Louis"
    @terminals['TUL'] = "Tulsa"
    @terminals['YYZ'] = "Toronto (Pearson)"
    
    @terminals = @terminals.sort_by { |iata, name| name }
  end
  
  def turn_signal_counter
  end
  
  def visor_cam
  end

end