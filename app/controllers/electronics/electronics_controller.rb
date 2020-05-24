class Electronics::ElectronicsController < ApplicationController

  def index
    add_breadcrumb "Electronics", electronics_root_path
  end

end
