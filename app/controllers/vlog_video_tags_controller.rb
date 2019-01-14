class VlogVideoTagsController < ApplicationController

  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def show
    @tag = VlogVideoTag.where(parameterized_name: params[:tag]).first
    raise ActiveRecord::RecordNotFound if (@tag.nil?)

    add_breadcrumb "StephenVlog", vlog_videos_path
    add_breadcrumb @tag.name, show_vlog_video_tag_path(@tag.parameterized_name)

    @vlog_videos = @tag.vlog_videos.eager_load(:vlog_video_tags).order(video_date: :desc)
    
    rescue ActiveRecord::RecordNotFound
    #flash[:warning] = "We couldnʼt find an airport with an ID of #{params[:id]}. Instead, weʼll give you a list of airports."
    redirect_to vlog_videos_path
  end

  def new
    @vlog_video_tag = VlogVideoTag.new
    add_breadcrumb "StephenVlog", vlog_videos_path
    add_breadcrumb "New Tag", new_vlog_video_tag_path
  end

  def create
    @vlog_video_tag = VlogVideoTag.new(vlog_video_tag_params)
    if @vlog_video_tag.save
      flash[:success] = "Successfully added the [#{@vlog_video_tag.name}] tag!"
      redirect_to vlog_videos_path
    else
      render "new"
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def vlog_video_tag_params
    params.require(:vlog_video_tag).permit(:name, :description)
  end

end