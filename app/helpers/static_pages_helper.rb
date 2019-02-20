module StaticPagesHelper
  
  # Takes one or more LinkButtons, and returns HTML for a collection of buttons.
  def link_buttons(*args)
    return content_tag(:div, class: %w(row button-row)) do
      render partial: "static_pages/link_button", collection: args, as: :button
    end
  end
  
  # Returns a responsive image.
  def project_image(path, type: nil, alt: nil, caption: nil, attribution: nil, href: nil)
    classes = %w(img-fluid project)
    extra_classes = {
      :ios_screenshot => %w(ios-screenshot),
      :osx_screenshot => %w(osx-screenshot),
      :screenshot     => %w(screenshot),
      :large          => %w(large)
    }
    classes.concat(extra_classes[type]) if extra_classes[type]
    path = PortfolioImage::ROOT_PATH + path
    image = image_tag(path, class: classes.join(' '), alt: alt)
    if (href)
      image = link_to(image, href, target: "_blank")
    elsif (type == :screenshot || type == :osx_screenshot || type == :large)
      image = link_to(image, path) 
    end
    caption = content_tag(:figcaption, caption) if caption.present?
    attribution = content_tag(:figcaption, "Image Credit: #{attribution}", class: "attribution") if attribution.present?
    return content_tag(:figure, image + attribution + caption)
  end
  
  # Returns an embedded YouTube video.
  def youtube_embed(video_id)
    html = %Q(<div class="row">)
    html += %Q(<div class="col-md-6 col-sm-8 offset-md-3 offset-sm-2">)
    html += %Q(<div class="embed-responsive embed-responsive-4by3">)
    html += %Q(<iframe width="420" height="315" src="https://www.youtube.com/embed/#{video_id}" frameborder="0" allowfullscreen></iframe>)
    html += "</div></div></div>"
    html.html_safe
  end
  
end
