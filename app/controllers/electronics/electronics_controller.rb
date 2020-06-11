class Electronics::ElectronicsController < ApplicationController

  def index
    add_breadcrumb "Electronics", electronics_root_path
    @computers = Computer.where(slug: ["pancake", "quesadilla"])
    @device_groupings = Part.current_no_computer.groupings
    @parts = @computers.map{|c| c.in_use_by_category.values}.flatten.uniq
    @parts = @parts | @device_groupings.values.flatten.uniq
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
