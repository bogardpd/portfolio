# Creates a clickable cover tile used in galleries
class Tile
  include ActionView::Helpers
  
  def initialize(caption: nil, img: nil, path: nil, title: nil, theme: nil, columns: nil)
    @path = path
    @title = title
    @img = img
    @caption = caption
    @theme = theme
    @columns = columns || 4
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
    classes = ["tile", "col-lg-#{@columns}", "col-sm-6"]
    classes << classes_custom
    classes << @theme if @theme
    return classes.compact.join(" ")
  end
  
  def classes_custom
    return nil
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