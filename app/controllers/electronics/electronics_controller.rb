class Electronics::ElectronicsController < ApplicationController

  def index
    add_breadcrumb "Electronics", electronics_root_path
    @computers = Computer.where(slug: ["pancake", "quesadilla"])
  end

end
