class VlogVideosController < ApplicationController
  # Controller for StephenVlog videos

  before_action :logged_in_user, only: [:new, :create, :edit, :update, :update_video_tags, :destroy]

  def index
    @vlog_videos = VlogVideo.eager_load(:vlog_video_tags).all.order(video_date: :desc)
    @vlog_video_tags = VlogVideoTag.eager_load(:vlog_videos).all.order(name: :asc)
    add_breadcrumb "StephenVlog", vlog_videos_path
  end

  def new
    @vlog_video = VlogVideo.new
    add_breadcrumb "StephenVlog", vlog_videos_path
    add_breadcrumb "New Video", new_vlog_video_path
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
    add_breadcrumb "StephenVlog", vlog_videos_path
    add_breadcrumb "Edit Video", edit_vlog_video_path(@vlog_video)

  rescue ActiveRecord::RecordNotFound
    flash[:warning] = "We couldnʼt find a video with an ID of #{params[:id]}."
    redirect_to vlog_videos_path
  end

  def update
    @vlog_video = VlogVideo.find(params[:id])
    if @vlog_video.update_attributes(vlog_video_params)
      flash[:success] = "Successfully updated #{@vlog_video.title}!"
      redirect_to vlog_videos_path
    else
      render "edit"
    end

  rescue ActiveRecord::RecordNotFound
    flash[:warning] = "We couldnʼt find a video with an ID of #{params[:id]}."
    redirect_to vlog_videos_path
  end

  def update_video_tags

  end

  def destroy
    VlogVideo.find(params[:id]).destroy
    flash[:success] = "Successfully deleted video!"
    redirect_to vlog_videos_path

  rescue ActiveRecord::RecordNotFound
    flash[:warning] = "We couldnʼt find a video with an ID of #{params[:id]}."
    redirect_to vlog_videos_path
  end

  private

  def vlog_video_params
    params.require(:vlog_video).permit(:title, :youtube_id, :video_date, :vlog_day, vlog_video_tag_ids: [])
  end

end
