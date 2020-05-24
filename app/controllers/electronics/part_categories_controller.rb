class Electronics::PartCategoriesController < ApplicationController

  before_action :logged_in_user, except: [:index, :show]

  def index
    add_part_categories_breadcrumbs
  end

  private

  def add_part_categories_breadcrumbs
    add_breadcrumb "Electronics", electronics_root_path
    add_breadcrumb "Part Categories", electronics_part_categories_path
  end

end
