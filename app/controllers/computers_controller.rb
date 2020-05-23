class ComputersController < ApplicationController

  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def index
    @computers = Computer.all
  end

  def show

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
