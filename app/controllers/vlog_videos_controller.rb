class VlogVideosController < ApplicationController
  # Controller for StephenVlog videos

  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def index
  end

  def new
    @vlog_video = VlogVideo.new
  end
  
  def create
    @vlog_video = VlogVideo.new(vlog_video_params)
    if @vlog_video.save
      flash[:success] = "Successfully added #{@vlog_video.title}!"
      redirect_to vlog_videos_path
    else
      render "new"
    end
  end

  private

  def vlog_video_params
    params.require(:vlog_video).permit(:title, :youtube_id, :video_date, :vlog_day)
  end

end
