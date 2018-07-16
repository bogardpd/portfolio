class StaticPagesController < ApplicationController
  
  def home
  end
  
  def about
  end
  
  def airport_code_puns
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
      render "static_pages/flight_historian/v#{params[:version]}"
      # TODO: redirect if page doesn't exist
    else
      @version_menu[:Overview][:active] = true
      render "static_pages/flight_historian/flight_historian"
    end
  end
  
  def fred_and_harry
  end
  
  def gallery_pax
    gallery_template
  end
  
  def gallery_starmen
    gallery_template
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
  
  def maps
    maps = %w(interstate-grid pax-west-area-map)
    if params[:map].present?
      if maps.include?(params[:map])
        render "static_pages/maps/#{params[:map].gsub("-","_")}"
      else
        redirect_to maps_path
      end
    else
      render "static_pages/maps/index"
    end
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
  
  def time_zone_chart
  end
  
  def turn_signal_counter
  end
  
  def visor_cam
  end
  
  private
  
  def gallery_template
    template = "static_pages/galleries/#{params[:gallery]}/index"
    @page = (params[:page] || 1).to_i
    if template_exists?(template)
      render :template => template
    else
      raise ActionController::RoutingError.new("Not Found")
    end
  end

end