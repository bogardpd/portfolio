class TerminalSilhouettesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  
  def index
    add_breadcrumb "Terminal Silhouettes", terminal_silhouettes_path
    @terminals = TerminalSilhouette.all.order(:city)
    @edit_links = logged_in? # Calling logged_in? from a partial can cause repeated queries if a cookie is bad
  end
  
  def new
    @terminal = TerminalSilhouette.new
  end
  
  def create
    @terminal = TerminalSilhouette.new(terminal_silhouette_params)
    if @terminal.save
      flash[:success] = "Successfully added #{@terminal.iata_code}!"
      redirect_to terminal_silhouettes_path
    else
      render 'new'
    end
  end
  
  def edit
    @terminal = TerminalSilhouette.find(params[:id])
  end
  
  def update
    @terminal = TerminalSilhouette.find(params[:id])
    if @terminal.update_attributes(terminal_silhouette_params)
      flash[:success] = "Successfully edited #{@terminal.iata_code}!"
      redirect_to terminal_silhouettes_path
    else
      render 'edit'
    end
  end
  
  def destroy
    terminal = TerminalSilhouette.find(params[:id])
    iata = terminal.iata_code
    terminal.destroy
    flash[:success] = "Successfully deleted #{iata}!"
    redirect_to terminal_silhouettes_path
  end
  
  private
  
    def terminal_silhouette_params
      params.require(:terminal_silhouette).permit(:iata_code, :city)
    end
  
end
