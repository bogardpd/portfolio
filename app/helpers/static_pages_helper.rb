module StaticPagesHelper
  
  # Takes one or more LinkButtons, and returns HTML for a collection of buttons.
  def link_buttons(*args)
    %Q(<div class="row button-row">#{render partial: 'static_pages/link_button', collection: args, as: :button}</div>).html_safe
  end
  
  # Returns a responsive image.
  def project_image(path, type: nil, alt: nil, caption: nil, attribution: nil, href: nil)
    classes = %w(img-responsive project)
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
    caption = "<figcaption>#{caption}</figcaption>" if caption.present?
    attribution = %Q(<figcaption class="attribution">Image Credit: #{attribution}</figcaption>) if attribution.present?
    return %Q(<figure>#{image}#{attribution}#{caption}</figure>).html_safe
  end
  
  # Returns an embedded YouTube video.
  def youtube_embed(video_id)
    html = %Q(<div class="row">)
    html += %Q(<div class="col-md-6 col-sm-8 col-md-offset-3 col-sm-offset-2">)
    html += %Q(<div class="embed-responsive embed-responsive-4by3">)
    html += %Q(<iframe width="420" height="315" src="https://www.youtube.com/embed/#{video_id}" frameborder="0" allowfullscreen></iframe>)
    html += "</div></div></div>"
    html.html_safe
  end
  
end
