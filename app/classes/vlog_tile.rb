# Creates a clickable YouTube cover tile used in StephenVlog pages
class VlogTile < Tile
  include ActionView::Helpers
  
  def initialize(title, youtube_id, date, details=nil, theme="stephenvlog")
    @path = "https://www.youtube.com/watch?v=#{youtube_id}"
    @title = title
    @img = "https://img.youtube.com/vi/#{youtube_id}/mqdefault.jpg"
    @caption = video_caption(date, details)
    @theme = theme
    @columns = %w(col-lg-6);
  end
  
  private
  
  def classes_custom
    return %w(tile-widescreen)
  end
  
  def video_caption(date, details)
    captions = Array.new
    captions << details if details
    captions << FormattedDate::text(Date.parse(date))
    return captions.join(" &middot ");
  end
end