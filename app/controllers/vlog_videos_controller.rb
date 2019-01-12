class VlogVideosController < ApplicationController
  # Controller for StephenVlog videos

  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def index
  end

  def new
    @vlog_video = VlogVideo.new
  end
  

end
