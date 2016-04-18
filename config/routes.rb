Rails.application.routes.draw do
  root 'static_pages#home'

  # Projects
  get 'earthbound-database' => 'static_pages#earthbound_database'
  get 'flight-historian' => 'static_pages#flight_historian'
  
  # About Pages
  get 'about' => 'static_pages#about'
  get 'resume' => 'static_pages#resume'
  
  # Other Pages
  get 'computers' => 'static_pages#computers'
  
end
