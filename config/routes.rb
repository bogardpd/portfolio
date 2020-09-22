Rails.application.routes.draw do
  
  root "static_pages#projects"
    
  # Authentication
  get    "login"  => "sessions#new"
  post   "login"  => "sessions#create"
  delete "logout" => "sessions#destroy"

  # Resources
  
  resources :terminal_silhouettes, except: [:show], path: "projects/terminal-silhouettes"
  resources :vlog_videos, except: [:show], path: "stephenvlog"
  resources :vlog_video_tags, except: [:index, :show], path: "stephenvlog/tags"
  get  "stephenvlog/tags/:tag"         => "vlog_video_tags#show",          as: :show_vlog_video_tag
  get  "stephenvlog/days(/:year)"      => "vlog_videos#show_days",         as: :show_vlog_days
  get  "stephenvlog/cheffcon-japan-2019" => "vlog_videos#cheffcon_japan_2019", as: :cheffcon_japan_2019
  get  "stephenvlog/location-project"  => "vlog_videos#location_project",  as: :stephenvlog_location_project

  
  namespace :electronics do
    root to: "electronics#index"
    resources :computers, param: :slug
    resources :part_categories, path: "part-categories", param: :slug
    resources :parts do
      resources :part_use_periods, except: [:index, :show], path: "use-periods"
    end
  end
  
  # Projects
  get "projects(/tags/:tag)" => "static_pages#projects", as: :projects
  
  get "projects/boarding-pass-parser"   => "static_pages#boarding_pass_parser",   as: :boarding_pass_parser
  get "projects/cad-models"             => "static_pages#cad_models",             as: :cad_models
  get "projects/earthbound-database"    => "static_pages#earthbound_database",    as: :earthbound_database
  get "projects/flight-directed-graphs" => "static_pages#flight_directed_graphs", as: :flight_directed_graphs
  get "projects/flight-historian"       => "static_pages#flight_historian",       as: :flight_historian
  get "projects/gate-13"                => "static_pages#gate_13",                as: :gate_13
  get "projects/gps-logging"            => "static_pages#gps_logging",            as: :gps_logging
  get "projects/nights-away-and-home"   => "static_pages#nights_away_and_home",   as: :nights_away_and_home
  get "projects/shared-itinerary"       => "static_pages#shared_itinerary",       as: :shared_itinerary
  get "projects/song-lyrics-graph"      => "static_pages#song_lyrics_graph",      as: :song_lyrics_graph
  get "projects/time-zone-chart"        => "static_pages#time_zone_chart",        as: :time_zone_chart
  get "projects/turn-signal-counter"    => "static_pages#turn_signal_counter",    as: :turn_signal_counter
  
  # Aliases and redirects

  get "computers" => redirect("electronics"), status: 301
  get "computers/old" => redirect("electronics"), status: 301

  get "boarding-pass-parser"   => redirect("projects/boarding-pass-parser",   status: 301)
  get "cad-models"             => redirect("projects/cad-models",             status: 301)
  get "earthbound-database"    => redirect("projects/earthbound-database",    status: 301)
  get "flight-historian"       => redirect("projects/flight-historian",       status: 301)
  get "gps-logging"            => redirect("projects/gps-logging",            status: 301)
  get "maps"                   => redirect("projects/tags/maps",              status: 301)
  get "projects/maps/gate-13"  => redirect("projects/gate-13",                status: 301)
  get "shared-itinerary"       => redirect("projects/shared-itinerary",       status: 301)
  get "turn-signal-counter"    => redirect("projects/turn-signal-counter",    status: 301)

  get "terminal-silhouettes"   => redirect("projects/terminal-silhouettes",   status: 301)
  get "terminal_silhouettes"   => redirect("projects/terminal-silhouettes",   status: 301)
  get "terminalsilhouettes"    => redirect("projects/terminal-silhouettes",   status: 301)
  get "terminals"              => redirect("projects/terminal-silhouettes",   status: 301)

  get "files/one-hundred-airports/:path.png" => redirect("https://s3.us-east-2.amazonaws.com/pbogardcom-images/one-hundred-airports/%{path}.png")
  get "files/terminal-silhouettes/png/:path.png" => redirect(PortfolioImage::ROOT_PATH + "projects/terminal-silhouettes/png/%{path}.png")
  get "files/terminal-silhouettes/svg/:path.svg" => redirect(PortfolioImage::ROOT_PATH + "projects/terminal-silhouettes/svg/%{path}.svg")
  
  # About Pages
  get "about"  => "static_pages#about"
  get "resume" => "static_pages#resume"
  
  # Other Pages
  get "airport-code-puns" => "static_pages#airport_code_puns"
  get "history"           => "static_pages#history"

  # RHIT
  get "rhit" => "static_pages#rhit"
  get "rhit/fast-track-calculus" => "static_pages#fast_track_calculus", as: :fast_track_calculus
  get "rhit/fast-track-calculus/fred-and-harry" => "static_pages#fred_and_harry", as: :fred_and_harry
  
  # Projects hosted on Portfolio
  get "timezones" => "time_zones#index"
  
  # Non-linked Pages
  get "games"             => "static_pages#games"
  get "games/idea-guy"    => "static_pages#idea_guy", as: :idea_guy
  get "hotel-pillow-fort" => "static_pages#hotel_pillow_fort"
  get "mco-lobby"         => "static_pages#mco_lobby"
  get "oreo"              => "static_pages#oreo"
  
  get "starmen-conventions" => "static_pages#starmen_conventions"
  get "starmen-conventions/:gallery(/:page)" => "static_pages#gallery_starmen", as: :starmen_con_gallery
  
  get "pax" => "static_pages#pax"
  get "pax/:gallery(/:page)" => "static_pages#gallery_pax", as: :pax_gallery
  
  # Certbot
  get "/.well-known/acme-challenge/:id" => "static_pages#letsencrypt"
  
 end
