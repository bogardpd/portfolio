class Electronics::PartUsePeriodsController < ApplicationController
  before_action :logged_in_user, except: []
  
  def new
    @use = PartUsePeriod.new
    @part = Part.find(params[:part_id])
    add_part_use_period_breadcrumbs
    add_breadcrumb(
      "New Use Period",
      new_electronics_part_part_use_period_path
    )
  rescue ActiveRecord::RecordNotFound
    redirect_to electronics_root_path
  end

  def create
    @use = PartUsePeriod.new(part_use_period_params)
    @part = Part.find(params[:part_id])
    @use.part = @part
    if @use.save
      flash[:success] = "Successfully added a use period to #{@part.model}!"
      redirect_to electronics_part_path(@part)
    else
      render "new"
    end
  end

  def edit
    @use = PartUsePeriod.find(params[:id])
    @part = Part.find(params[:part_id])
    add_part_use_period_breadcrumbs
    add_breadcrumb(
      "Edit Use Period",
      edit_electronics_part_part_use_period_path(@part, @use)
    )
  end

  def update
    @use = PartUsePeriod.find(params[:id])
    @part = Part.find(params[:part_id])
    @use.part = @part
    if @use.update_attributes(part_use_period_params)
      flash[:success] = "Successfully updated a use period!"
      redirect_to electronics_part_path(@part)
    else
      render "edit"
    end
  end

  def destroy
    use = PartUsePeriod.find(params[:id])
    part = Part.find(params[:part_id])
    use.destroy
    flash[:success] = "Successfully deleted a use period!"
    redirect_to electronics_part_path(part)
  end

  private

  def add_part_use_period_breadcrumbs
    add_breadcrumb "Electronics", electronics_root_path
    add_breadcrumb "Parts", electronics_parts_path
    add_breadcrumb @part.model, electronics_part_path(@part)
  end

  def part_use_period_params
    params.require(:part_use_period).permit(:computer_id, :start_date, :end_date)
  end

end
