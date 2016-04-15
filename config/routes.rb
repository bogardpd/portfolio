Rails.application.routes.draw do
  root 'static_pages#home'

  get 'flight-historian' => 'static_pages#flight_historian'
  get 'earthbound-database' => 'static_pages#earthbound_database'
end
