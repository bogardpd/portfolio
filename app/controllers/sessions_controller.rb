class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.find_by(username: params[:session][:username])
    if user && user.authenticate(params[:session][:password])
      log_in user
      remember user
      flash[:success] = "Welcome, #{user.username}. You have successfully logged in."
      redirect_to root_path
    else
      flash.now[:danger] = 'Invalid username/password!'
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    flash[:success] = 'You have successfully logged out.'
    redirect_to root_url
  end
  
end
