Rails.application.routes.draw do
  root 'static_pages#home'

  # Projects
  get 'earthbound-database' => 'static_pages#earthbound_database'
  get 'flight-historian' => 'static_pages#flight_historian'
  
  # About Pages
  
  
  # Other Pages
  get 'computers' => 'static_pages#computers'
  
end
