Rails.application.routes.draw do
  root 'static_pages#home'
  
  # Authentication
  get    'login'  => 'sessions#new'
  post   'login'  => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  
  # Projects
  get 'boarding-pass-parser'   => 'static_pages#boarding_pass_parser'
  get 'cad-models'             => 'static_pages#cad_models'
  get 'earthbound-database'    => 'static_pages#earthbound_database'
  get 'flight-historian'       => 'static_pages#flight_historian'
  get 'hotel-internet-quality' => 'static_pages#hotel_internet_quality'
  get 'shared-itinerary'       => 'static_pages#shared_itinerary'
  get 'terminal-silhouettes'   => 'static_pages#terminal_silhouettes'
  get 'turn-signal-counter'    => 'static_pages#turn_signal_counter'
  get 'visor-cam'              => 'static_pages#visor_cam'
  
  get 'gps-logging',                     to: 'static_pages#gps_logging'
  get 'gps-logging/garmin-google-earth', to: 'static_pages#gps_logging_garmin_google_earth'
  get 'gps-logging/garmin-osm',          to: 'static_pages#gps_logging_garmin_osm'
  get 'gps-logging/ios-google-earth',    to: 'static_pages#gps_logging_ios_google_earth'
  get 'gps-logging/ios-osm',             to: 'static_pages#gps_logging_ios_osm'
  
  # About Pages
  get 'about'  => 'static_pages#about'
  get 'resume' => 'static_pages#resume'
  
  # Other Pages
  get 'computers'       => 'static_pages#computers'
  get 'computers/old'   => 'static_pages#old_computers', :as => :old_computers
  get 'ingress-mosaics' => 'static_pages#ingress_mosaics'
  get 'ingress-murals', :to => redirect('/ingress-mosaics', :status => 301)
  get 'history'         => 'static_pages#history'
  
  # Non-linked Pages
  get 'stephenvlog'     => 'static_pages#stephenvlog'
  get 'oreo'            => 'static_pages#oreo'
  get 'rhit/fast-track-calculus' => 'static_pages#fast_track_calculus', :as => :fast_track_calculus
  get 'rhit/fred-and-harry' => 'static_pages#fred_and_harry', :as => :fred_and_harry
  get 'starmen-conventions' => 'static_pages#starmen_conventions'
  get 'starmen-conventions/:gallery(/:page)' => 'static_pages#gallery', :as => :starmen_con_gallery
  
  resources :books
  get '/reading-list', :to => redirect('/books', :status => 301)
  
  # Certbot
  get '/.well-known/acme-challenge/:id' => 'static_pages#letsencrypt'
  
   # Permanently redirect legacy flight log routes to Flight Historian:

  get '/flightlog',       :to => redirect('https://www.flighthistorian.com/', :status => 301)
  get '/flightlog/*all',  :to => redirect('https://www.flighthistorian.com/', :status => 301)

  get '/flights',         :to => redirect('https://www.flighthistorian.com/flights', :status => 301)
  get '/flights/*all',    :to => redirect('https://www.flighthistorian.com/flights', :status => 301)

  get '/trips',           :to => redirect('https://www.flighthistorian.com/trips', :status => 301)
  get '/trips/*all',      :to => redirect('https://www.flighthistorian.com/trips', :status => 301)

  get '/aircraft',        :to => redirect('https://www.flighthistorian.com/aircraft', :status => 301)
  get '/aircraft/*all',   :to => redirect('https://www.flighthistorian.com/aircraft', :status => 301)

  get '/airlines',        :to => redirect('https://www.flighthistorian.com/airlines', :status => 301)
  get '/airlines/*all',   :to => redirect('https://www.flighthistorian.com/airlines', :status => 301)
  get '/operators/*all',  :to => redirect('https://www.flighthistorian.com/airlines', :status => 301)

  get '/airports',        :to => redirect('https://www.flighthistorian.com/airports', :status => 301)
  get '/airports/*all',   :to => redirect('https://www.flighthistorian.com/airports', :status => 301)

  get '/classes',         :to => redirect('https://www.flighthistorian.com/classes', :status => 301)
  get '/classes/*all',    :to => redirect('https://www.flighthistorian.com/classes', :status => 301)

  get '/tails',           :to => redirect('https://www.flighthistorian.com/tails', :status => 301)
  get '/tails/*all',      :to => redirect('https://www.flighthistorian.com/tails', :status => 301)

  get '/routes',          :to => redirect('https://www.flighthistorian.com/routes', :status => 301)
  get '/routes/*all',     :to => redirect('https://www.flighthistorian.com/routes', :status => 301)

end
