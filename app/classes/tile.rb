# Creates a clickable cover tile used in galleries
class Tile
  include ActionView::Helpers
  
  def initialize(caption: nil, img: nil, path: nil, title: nil, date_string: nil, theme: nil, columns: nil)
    @path = path
    @title = title
    @img = img
    @caption = caption
    @date_string = date_string
    @theme = theme
    @columns = columns || %w(col-xl-4 col-lg-6)
  end
  
  def show
    tile = ActiveSupport::SafeBuffer.new
    
    tile << image_tag(image_source, class: "img-fluid") if image_source
    tile << content_tag(:h3, title) if title
    tile << content_tag(:p, caption) if caption
    tile << content_tag(:p, date_string) if date_string

    tile = link_to(tile, path, class: %w(btn btn-link btn-block)) if path
    
    return content_tag(:div, tile, class: tile_classes)
  end
  
  private
  
  def caption
    return @caption
  end
  
  def classes_custom
    return nil
  end
  
  def date_string
    return @date_string
  end

  def image_source
    return @img
  end
  
  def path
    return @path
  end
  
  def tile_classes
    classes = ["tile"]
    classes << @columns
    classes << classes_custom
    classes << @theme if @theme
    return classes.compact
  end
  
  def title
    return @title
  end
  
end