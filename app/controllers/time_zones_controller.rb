class TimeZonesController < ApplicationController
  layout "time_zone_controller"
  
  def index
    @number_of_starting_rows = 3
  end
end
