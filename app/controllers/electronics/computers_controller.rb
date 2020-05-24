class Electronics::ComputersController < ApplicationController

  before_action :logged_in_user, except: [:index, :show]
  
  def index
    @computers = Computer.all
    add_computer_breadcrumbs
  end

  def show
    @computer = Computer.find_by!(slug: params[:slug])
    add_breadcrumb "Computers", electronics_computers_path
    add_breadcrumb @computer.name, electronics_computer_path(@computer.slug)

  rescue ActiveRecord::RecordNotFound
    flash[:warning] = "Sorry, we couldn’t find a computer named #{params[:slug]}."
    redirect_to electronics_computers_path
  end

  def new
    @computer = Computer.new
  end

  def create
    @computer = Computer.new(computer_params)
    if @computer.save
      flash[:success] = "Successfully added #{@computer.name}!"
      redirect_to electronics_computers_path
    else
      render "new"
    end
  end

  def edit
    @computer = Computer.find_by!(slug: params[:slug])
    add_breadcrumb "Computers", electronics_computers_path
    add_breadcrumb @computer.name, electronics_computer_path(@computer.slug)
    add_breadcrumb "Edit", edit_electronics_computer_path(@computer.slug)
  end

  def update
    @computer = Computer.find_by!(slug: params[:slug])
    if @computer.update_attributes(computer_params)
      flash[:success] = "Successfully updated #{@computer.name}!"
      redirect_to electronics_computer_path(@computer.slug)
    else
      render "edit"
    end
  end

  def destroy
    computer = Computer.find_by!(slug: params[:slug])
    name = computer.name
    computer.destroy
    flash[:success] = "Successfully deleted #{name}!"
    redirect_to electronics_computers_path
  end

  private

  def add_computer_breadcrumbs
    add_breadcrumb "Electronics", electronics_root_path
    add_breadcrumb "Computers", electronics_computers_path
  end

  def computer_params
    params.require(:computer).permit(:name, :model, :description, :form_factor, :purchase_date, :disposal_date)
  end

end
