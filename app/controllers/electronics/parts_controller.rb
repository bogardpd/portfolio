class Electronics::PartsController < ApplicationController

  before_action :logged_in_user, except: [:index, :show]

  def index
    add_parts_breadcrumbs
  end

  private

  def add_parts_breadcrumbs
    add_breadcrumb "Electronics", electronics_root_path
    add_breadcrumb "Parts", electronics_parts_path
  end

end