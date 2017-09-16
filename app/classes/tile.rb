# Creates a clickable cover tile used in galleries
class Tile
  include ActionView::Helpers
  
  def initialize(caption: nil, img: nil, path: nil, title: nil, theme: nil)
    @path = path
    @title = title
    @img = img
    @caption = caption
    @theme = theme
  end
  
  def show
    html = String.new
    tile = String.new
    
    
    tile << image_tag(image_source) if image_source
    tile << "<h3>#{title}</h3>" if title
    tile << "<p>#{caption}</p>" if caption
    
    html << %Q(<div class="#{tile_classes}">)
    if path
      html << link_to(tile.html_safe, @path, class: "btn btn-link btn-block")
    else
      html << tile.html_safe
    end
    html << "</div>"
    
    return html.html_safe
  end
  
  private
  
  def caption
    return @caption
  end
  
  def tile_classes
    classes = %w(tile)
    classes << cols
    classes << @theme if @theme
    return classes.join(" ")
  end
  
  def cols
    return %w(col-lg-4 col-sm-6)
  end
  
  def image_source
    return @img
  end
  
  def title
    return @title
  end
  
  def path
    return @path
  end
  
end