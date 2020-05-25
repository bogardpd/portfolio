class Electronics::PartCategoriesController < ApplicationController

  before_action :logged_in_user, except: [:index, :show]

  def index
    add_part_category_breadcrumbs
    @categories = PartCategory.all.order(:name)
  end

  def show
    @category = PartCategory.find_by!(slug: params[:slug])
    add_part_category_breadcrumbs
    add_breadcrumb @category.name, electronics_part_category_path(@category.slug)
  rescue ActiveRecord::RecordNotFound
    flash[:warning] = "Sorry, we couldn’t find a part category named #{params[:slug]}."
    redirect_to electronics_part_categories_path
  end

  def new
    @category = PartCategory.new
    add_part_category_breadcrumbs
    add_breadcrumb "New", new_electronics_part_category_path
  end

  def create
    @category = PartCategory.new(part_category_params)
    if @category.save
      flash[:success] = "Successfully added #{@category.name}!"
      redirect_to electronics_part_categories_path
    else
      render "new"
    end
  end

  private

  def add_part_category_breadcrumbs
    add_breadcrumb "Electronics", electronics_root_path
    add_breadcrumb "Part Categories", electronics_part_categories_path
  end

  def part_category_params
    params.require(:part_category).permit(:name, :name_singular, :name_lowercase_plural, :description)
  end

end
