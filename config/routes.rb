Rails.application.routes.draw do
  root 'static_pages#home'

  # Projects
  get 'cad-models' => 'static_pages#cad_models'
  get 'earthbound-database' => 'static_pages#earthbound_database'
  get 'flight-historian' => 'static_pages#flight_historian'
  
  get 'gps-logging' => 'static_pages#gps_logging'
  get 'gps-logging/garmin' => 'static_pages#gps_logging_garmin'
  get 'gps-logging/ios' => 'static_pages#gps_logging_ios'
  
  get 'hotel-internet-quality' => 'static_pages#hotel_internet_quality'
  get 'terminal-silhouettes' => 'static_pages#terminal_silhouettes'
  get 'turn-signal-counter' => 'static_pages#turn_signal_counter'
  get 'visor-cam' => 'static_pages#visor_cam'
  
  # About Pages
  get 'about' => 'static_pages#about'
  get 'resume' => 'static_pages#resume'
  
  # Other Pages
  get 'computers' => 'static_pages#computers'
  get 'ingress-murals' => 'static_pages#ingress_murals'
  
end
