class Electronics::ElectronicsController < ApplicationController

  def index
    add_breadcrumb "Electronics", electronics_root_path
    @computers = Computer.where(slug: ["pancake", "quesadilla"])
    @link_buttons = [
      LinkButton.new(
        "Computer History",
        nil,
        electronics_computers_path
      ),
      LinkButton.new(
        "Devices and Parts by Category",
        nil,
        electronics_part_categories_path
      )
    ]
  end

end
