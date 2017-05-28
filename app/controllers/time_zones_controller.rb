class TimeZonesController < ApplicationController
  layout "time_zone_controller"
  
  def index
  end
  
  # Return an SVG file
  def svg
    response.headers["Content-Type"] = "image/svg+xml"
    render body: %Q(<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="chart" width="1024" height="768"><rect x="100" y="100" width="200" height="100" stroke="black" fill="red" /></svg>)
  end
  
end
