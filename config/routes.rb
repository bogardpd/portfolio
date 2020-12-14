Rails.application.routes.draw do
  
  root "static_pages#home"
    
  # Authentication
  get    "login"  => "sessions#new"
  post   "login"  => "sessions#create"
  delete "logout" => "sessions#destroy"
    
  # Certbot
  get "/.well-known/acme-challenge/:id" => "static_pages#letsencrypt"
  
  # Redirects to paulbogard.net

  get "/about" =>
    redirect("https://paulbogard.net/", status: 301)
  get "/airport-code-puns" =>
    redirect("https://paulbogard.net/airport-code-puns/", status: 301)
  get "(/projects)/boarding-pass-parser" =>
    redirect("https://paulbogard.net/boarding-pass-parser/", status: 301)
  get "(/projects)/cad-models" =>
    redirect("https://paulbogard.net/cad-models/", status: 301)
  get "/computers(/old)" =>
    redirect("https://paulbogard.net/computers/", status: 301)
  get "/electronics(/*all)" =>
    redirect("https://paulbogard.net/computers/", status: 301)
  get "(/projects)/earthbound-database" =>
    redirect("https://paulbogard.net/earthbound-database/", status: 301)
  get "(/projects)/flight-directed-graphs" =>
    redirect("https://paulbogard.net/flight-graphs/", status: 301)
  get "(/projects)/flight-historian" =>
    redirect("https://paulbogard.net/flight-historian/", status: 301)
  get "/games" =>
    redirect("https://paulbogard.net/games/", status: 301)
  get "(/projects(/maps))/gate-13" =>
    redirect("https://paulbogard.net/blog/20200118-unlucky-gate-13/", status: 301)
  get "(/projects)/gps-logging" =>
    redirect("https://paulbogard.net/gps-logging/", status: 301)
  get "/hotel-pillow-fort" =>
    redirect("https://paulbogard.net/hotel-pillow-fort/", status: 301)
  get "/history" =>
    redirect("https://paulbogard.net/personal-website-history/", status: 301)
  get "/maps" =>
    redirect("https://paulbogard.net/maps/", status: 301)
  get "/mco-lobby" =>
    redirect("https://paulbogard.net/mco-lobby/", status: 301)
  get "(/projects)/nights-away-and-home" =>
    redirect("https://paulbogard.net/blog/20200419-time-at-home-during-covid-19/", status: 301)
  get "/oreo" =>
    redirect("https://paulbogard.net/oreo/", status: 301)
  get "/pax(/:gallery(/:page))" =>
    redirect("https://paulbogard.net/pax/", status: 301)
  get "/projects(/tags/:tag)" =>
    redirect("https://paulbogard.net/projects/", status: 301)
  get "/resume" =>
    redirect("https://paulbogard.net/resume/", status: 301)
  get "/rhit" =>
    redirect("https://paulbogard.net/rhit/", status: 301)
  get "/rhit/fast-track-calculus" =>
    redirect("https://paulbogard.net/rhit/fast-track-calculus/", status: 301)
  get "/rhit/fast-track-calculus/fred-and-harry" =>
    redirect("https://paulbogard.net/rhit/fred-and-harry/", status: 301)
  get "(/projects)/shared-itinerary" =>
    redirect("https://paulbogard.net/shared-itinerary/", status: 301)
  get "(/projects)/song-lyrics-graph" =>
    redirect("https://paulbogard.net/blog/20200613-song-lyrics-graph/", status: 301)
  get "/stephenvlog(/tags/:tag)" =>
    redirect("https://paulbogard.net/stephenvlog/", status: 301)
  get "/stephenvlog/days(/:year)" =>
    redirect("https://paulbogard.net/stephenvlog/days/", status: 301)
  get  "/stephenvlog/cheffcon-japan-2019" =>
    redirect("https://paulbogard.net/stephenvlog/cheffcon-japan-2019/", status: 301)
  get  "/stephenvlog/location-project" =>
    redirect("https://paulbogard.net/stephenvlog/location-project/", status: 301)
  get "(/projects)/terminal-silhouettes" =>
    redirect("https://paulbogard.net/terminal-silhouettes/", status: 301)
  get "(/projects)/time-zone-chart" =>
    redirect("https://paulbogard.net/time-zone-chart/", status: 301)
  get "/timezones" =>
    redirect("https://paulbogard.net/time-zones/", status: 301)
  get "(/projects)/turn-signal-counter" =>
    redirect("https://paulbogard.net/turn-signal-counter/", status: 301)
  
end
