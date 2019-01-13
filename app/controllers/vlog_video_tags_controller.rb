class VlogVideoTagsController < ApplicationController

  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def new
    @vlog_video_tag = VlogVideoTag.new
  end

  def create
    @vlog_video_tag = VlogVideoTag.new(vlog_video_tag_params)
    if @vlog_video_tag.save
      flash[:success] = "Successfully added the <strong>#{@vlog_video_tag.name}</strong> tag!"
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