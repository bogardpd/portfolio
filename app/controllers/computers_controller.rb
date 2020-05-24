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

  private

  def computer_params
    params.require(:computer).permit(:name, :model, :description, :form_factor, :purchase_date, :disposal_date)
  end

end
