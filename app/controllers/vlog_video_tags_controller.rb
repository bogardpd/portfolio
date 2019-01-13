class VlogVideoTagsController < ApplicationController

  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

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