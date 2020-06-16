class Electronics::ElectronicsController < ApplicationController

  def index
    add_breadcrumb "Electronics", electronics_root_path
    @computers = Computer.where(slug: ["pancake", "quesadilla"])
    device_cat_collection = Part.current_no_computer
    @device_groupings = device_cat_collection.groupings
    device_parts = device_cat_collection.parts
    computer_parts = @computers.map{|c| c.in_use_by_category.parts}.flatten.uniq
    @parts = computer_parts | device_parts
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
