class ComputersController < ApplicationController

  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def index
    @computers = Computer.all
  end

  def show

  end

end
