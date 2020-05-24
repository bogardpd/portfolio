class ComputersController < ApplicationController

  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def index
    @computers = Computer.all
    add_breadcrumb "Computers", computers_path
  end

  def show
    @computer = Computer.find_by!(slug: params[:slug])
    add_breadcrumb("Computers", computers_path)
    add_breadcrumb(@computer.name, computer_path(@computer.slug))
  end

  def new
    @computer = Computer.new
  end

  def create
    @computer = Computer.new(computer_params)
    if @computer.save
      flash[:success] = "Successfully added #{@computer.name}!"
      redirect_to computers_path
    else
      render "new"
    end
  end

  def edit
    @computer = Computer.find_by!(slug: params[:slug])
  end

  def update
    @computer = Computer.find_by!(slug: params[:slug])
    if @computer.update_attributes(computer_params)
      flash[:success] = "Successfully updated #{@computer.name}!"
      redirect_to computer_path(@computer.slug)
    else
      render "edit"
    end
  end

  private

  def computer_params
    params.require(:computer).permit(:name, :model, :description, :form_factor, :purchase_date, :disposal_date)
  end

end
