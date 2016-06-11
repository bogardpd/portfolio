Rails.application.routes.draw do
  root 'static_pages#home'
  
  # Authentication
  get    'login'  => 'sessions#new'
  post   'login'  => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  
  # Projects
  get 'cad-models'             => 'static_pages#cad_models'
  get 'earthbound-database'    => 'static_pages#earthbound_database'
  get 'flight-historian'       => 'static_pages#flight_historian'
  get 'hotel-internet-quality' => 'static_pages#hotel_internet_quality'
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
  get 'computers'      => 'static_pages#computers'
  get 'ingress-murals' => 'static_pages#ingress_murals'
  
  # Non-linked Pages
  get 'reading-list' => 'static_pages#reading_list'
  get 'stephenvlog'  => 'static_pages#stephenvlog'
  
  # Permanently redirect legacy flight log routes to Flight Historian:

  get '/flightlog',       :to => redirect('http://www.flighthistorian.com/', :status => 301)
  get '/flightlog/*all',  :to => redirect('http://www.flighthistorian.com/', :status => 301)

  get '/flights',         :to => redirect('http://www.flighthistorian.com/flights', :status => 301)
  get '/flights/*all',    :to => redirect('http://www.flighthistorian.com/flights', :status => 301)

  get '/trips',           :to => redirect('http://www.flighthistorian.com/trips', :status => 301)
  get '/trips/*all',      :to => redirect('http://www.flighthistorian.com/trips', :status => 301)

  get '/aircraft',        :to => redirect('http://www.flighthistorian.com/aircraft', :status => 301)
  get '/aircraft/*all',   :to => redirect('http://www.flighthistorian.com/aircraft', :status => 301)

  get '/airlines',        :to => redirect('http://www.flighthistorian.com/airlines', :status => 301)
  get '/airlines/*all',   :to => redirect('http://www.flighthistorian.com/airlines', :status => 301)
  get '/operators/*all',  :to => redirect('http://www.flighthistorian.com/airlines', :status => 301)

  get '/airports',        :to => redirect('http://www.flighthistorian.com/airports', :status => 301)
  get '/airports/*all',   :to => redirect('http://www.flighthistorian.com/airports', :status => 301)

  get '/classes',         :to => redirect('http://www.flighthistorian.com/classes', :status => 301)
  get '/classes/*all',    :to => redirect('http://www.flighthistorian.com/classes', :status => 301)

  get '/tails',           :to => redirect('http://www.flighthistorian.com/tails', :status => 301)
  get '/tails/*all',      :to => redirect('http://www.flighthistorian.com/tails', :status => 301)

  get '/routes',          :to => redirect('http://www.flighthistorian.com/routes', :status => 301)
  get '/routes/*all',     :to => redirect('http://www.flighthistorian.com/routes', :status => 301)

end
