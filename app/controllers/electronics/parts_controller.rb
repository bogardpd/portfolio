class Electronics::PartsController < ApplicationController

  before_action :logged_in_user, except: [:index, :show]

  def index
    @parts = Part.all
    add_part_breadcrumbs
  end

  def show
    @part = Part.find(params[:id])
    add_part_breadcrumbs
    add_breadcrumb @part.model, electronics_part_path(@part)
  rescue ActiveRecord::RecordNotFound
    flash[:warning] = "Sorry, we couldn’t find a matching part."
    redirect_to electronics_parts_path
  end

  def new
    @part = Part.new
    add_part_breadcrumbs
    add_breadcrumb "New", new_electronics_part_path
  end

  def create
    @part = Part.new(part_params)
    if @part.save
      flash[:success] = "Successfully added #{@part.model}!"
      redirect_to electronics_parts_path
    else
      render "new"
    end
  end

  def edit
    @part = Part.find(params[:id])
    add_part_breadcrumbs
    add_breadcrumb @part.model, electronics_part_path(@part)
    add_breadcrumb "Edit", edit_electronics_part_path(@part)
  end

  def update
    @part = Part.find(params[:id])
    if @part.update_attributes(part_params)
      flash[:success] = "Successfully updated #{@part.model}!"
      redirect_to electronics_part_path(@part)
    else
      render "edit"
    end
  end

  def destroy
    part = Part.find(params[:id])
    model = part.model
    part.destroy
    flash[:success] = "Successfully deleted #{model}!"
    redirect_to electronics_parts_path
  end

  private

  def add_part_breadcrumbs
    add_breadcrumb "Electronics", electronics_root_path
    add_breadcrumb "Parts", electronics_parts_path
  end

  def part_params
    params.require(:part).permit(:disposal_date, :model, :name, :note, :part_number, :purchase_date, :specs, part_category_ids: [])
  end

end