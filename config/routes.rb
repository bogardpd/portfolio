Rails.application.routes.draw do
  
  root "static_pages#home"
  
  # Authentication
  get    "login"  => "sessions#new"
  post   "login"  => "sessions#create"
  delete "logout" => "sessions#destroy"
  
  # Projects
  get "projects" => "static_pages#home"
  
  get "projects/boarding-pass-parser"   => "static_pages#boarding_pass_parser",   as: :boarding_pass_parser
  get "projects/cad-models"             => "static_pages#cad_models",             as: :cad_models
  get "projects/earthbound-database"    => "static_pages#earthbound_database",    as: :earthbound_database
  get "projects/flight-historian"       => "static_pages#flight_historian",       as: :flight_historian
  get "projects/hotel-internet-quality" => "static_pages#hotel_internet_quality", as: :hotel_internet_quality
  get "projects/shared-itinerary"       => "static_pages#shared_itinerary",       as: :shared_itinerary
  get "projects/terminal-silhouettes"   => "static_pages#terminal_silhouettes",   as: :terminal_silhouettes
  get "projects/time-zone-chart"        => "static_pages#time_zone_chart",        as: :time_zone_chart
  get "projects/turn-signal-counter"    => "static_pages#turn_signal_counter",    as: :turn_signal_counter
  get "projects/visor-cam"              => "static_pages#visor_cam",              as: :visor_cam
  
  get "projects/gps-logging"                     => "static_pages#gps_logging",                     as: :gps_logging
  get "projects/gps-logging/garmin-google-earth" => "static_pages#gps_logging_garmin_google_earth", as: :gps_logging_garmin_google_earth
  get "projects/gps-logging/garmin-osm"          => "static_pages#gps_logging_garmin_osm",          as: :gps_logging_garmin_osm
  get "projects/gps-logging/ios-google-earth"    => "static_pages#gps_logging_ios_google_earth",    as: :gps_logging_ios_google_earth
  get "projects/gps-logging/ios-osm"             => "static_pages#gps_logging_ios_osm",             as: :gps_logging_ios_osm
  
  get "boarding-pass-parser"   => redirect("projects/boarding-pass-parser",   status: 301)
  get "cad-models"             => redirect("projects/cad-models",             status: 301)
  get "earthbound-database"    => redirect("projects/earthbound-database",    status: 301)
  get "flight-historian"       => redirect("projects/flight-historian",       status: 301)
  get "hotel-internet-quality" => redirect("projects/hotel-internet-quality", status: 301)
  get "shared-itinerary"       => redirect("projects/shared-itinerary",       status: 301)
  get "terminal-silhouettes"   => redirect("projects/terminal-silhouettes",   status: 301)
  get "turn-signal-counter"    => redirect("projects/turn-signal-counter",    status: 301)
  get "visor-cam"              => redirect("projects/visor-cam",              status: 301)
  get "gps-logging"                     => redirect("projects/gps-logging",                     status: 301)
  get "gps-logging/garmin-google-earth" => redirect("projects/gps-logging/garmin-google-earth", status: 301)
  get "gps-logging/garmin-osm"          => redirect("projects/gps-logging/garmin-osm",          status: 301)
  get "gps-logging/ios-google-earth"    => redirect("projects/gps-logging/ios-google-earth",    status: 301)
  get "gps-logging/ios-osm"             => redirect("projects/gps-logging/ios-osm",             status: 301)
  
  # About Pages
  get "about"  => "static_pages#about"
  get "resume" => "static_pages#resume"
  
  # Other Pages
  get "computers"       => "static_pages#computers"
  get "computers/old"   => "static_pages#old_computers", :as => :old_computers
  get "ingress-mosaics" => "static_pages#ingress_mosaics"
  get "ingress-murals", :to => redirect("/ingress-mosaics", :status => 301)
  get "history"         => "static_pages#history"
  
  # Projects hosted on Portfolio
  get "timezones" => "time_zones#index"
  
  # Non-linked Pages
  get "stephenvlog"     => "static_pages#stephenvlog"
  get "oreo"            => "static_pages#oreo"
  get "rhit/fast-track-calculus" => "static_pages#fast_track_calculus", :as => :fast_track_calculus
  get "rhit/fred-and-harry" => "static_pages#fred_and_harry", :as => :fred_and_harry
  get "starmen-conventions" => "static_pages#starmen_conventions"
  get "starmen-conventions/:gallery(/:page)" => "static_pages#gallery", :as => :starmen_con_gallery
  
  resources :books
  get "/reading-list", :to => redirect("/books", :status => 301)
  
  # Certbot
  get "/.well-known/acme-challenge/:id" => "static_pages#letsencrypt"
  
   # Permanently redirect legacy flight log routes to Flight Historian:

  get "/flightlog",       :to => redirect("https://www.flighthistorian.com/", :status => 301)
  get "/flightlog/*all",  :to => redirect("https://www.flighthistorian.com/", :status => 301)

  get "/flights",         :to => redirect("https://www.flighthistorian.com/flights", :status => 301)
  get "/flights/*all",    :to => redirect("https://www.flighthistorian.com/flights", :status => 301)

  get "/trips",           :to => redirect("https://www.flighthistorian.com/trips", :status => 301)
  get "/trips/*all",      :to => redirect("https://www.flighthistorian.com/trips", :status => 301)

  get "/aircraft",        :to => redirect("https://www.flighthistorian.com/aircraft", :status => 301)
  get "/aircraft/*all",   :to => redirect("https://www.flighthistorian.com/aircraft", :status => 301)

  get "/airlines",        :to => redirect("https://www.flighthistorian.com/airlines", :status => 301)
  get "/airlines/*all",   :to => redirect("https://www.flighthistorian.com/airlines", :status => 301)
  get "/operators/*all",  :to => redirect("https://www.flighthistorian.com/airlines", :status => 301)

  get "/airports",        :to => redirect("https://www.flighthistorian.com/airports", :status => 301)
  get "/airports/*all",   :to => redirect("https://www.flighthistorian.com/airports", :status => 301)

  get "/classes",         :to => redirect("https://www.flighthistorian.com/classes", :status => 301)
  get "/classes/*all",    :to => redirect("https://www.flighthistorian.com/classes", :status => 301)

  get "/tails",           :to => redirect("https://www.flighthistorian.com/tails", :status => 301)
  get "/tails/*all",      :to => redirect("https://www.flighthistorian.com/tails", :status => 301)

  get "/routes",          :to => redirect("https://www.flighthistorian.com/routes", :status => 301)
  get "/routes/*all",     :to => redirect("https://www.flighthistorian.com/routes", :status => 301)

end
