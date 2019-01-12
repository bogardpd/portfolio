class VlogVideosController < ApplicationController
  # Controller for StephenVlog videos

  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def index
    @vlog_videos = VlogVideo.order(video_date: :desc)
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

  def edit
    @vlog_video = VlogVideo.find(params[:id])
  end

  def update
    @vlog_video = VlogVideo.find(params[:id])
    if @vlog_video.update_attributes(vlog_video_params)
      flash[:success] = "Successfully updated #{@vlog_video.title}!"
      redirect_to vlog_videos_path
    else
      render "edit"
    end
  end

  def destroy
    VlogVideo.find(params[:id]).destroy
    flash[:success] = "Successfully deleted video!"
    redirect_to vlog_videos_path
  end

  private

  def vlog_video_params
    params.require(:vlog_video).permit(:title, :youtube_id, :video_date, :vlog_day)
  end

end
