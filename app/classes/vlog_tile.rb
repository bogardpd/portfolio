# Creates a clickable YouTube cover tile used in StephenVlog pages
class VlogTile < Tile
  include ActionView::Helpers
  
  def initialize(title, youtube_id, date, details=nil, theme=nil)
    @path = "http://www.youtube.com/watch?v=#{youtube_id}"
    @title = title
    @img = "http://img.youtube.com/vi/#{youtube_id}/mqdefault.jpg"
    @caption = video_caption(date, details)
    @theme = theme
  end
  
  private
  
  def video_caption(date, details)
    captions = Array.new
    captions << details if details
    captions << FormattedDate::text(Date.parse(date))
    return captions.join(" &middot ");
  end
end