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
      :large          => %w(large),
      :computer_thumbnail => %w(computer-thumbnail)
    }
    allowed_tags = %w(abbr a)
    allowed_attributes = %w(href target)
    classes.concat(extra_classes[type]) if extra_classes[type]
    path = PortfolioImage::ROOT_PATH + path
    image = image_tag(path, class: classes.join(' '), alt: alt)
    if (href)
      image = link_to(image, href, target: "_blank")
    elsif (type == :screenshot || type == :osx_screenshot || type == :large)
      image = link_to(image, path) 
    end
    caption = content_tag(:figcaption, sanitize(caption, tags: allowed_tags, attributes: allowed_attributes)) if caption.present?
    attribution = content_tag(:figcaption, ActiveSupport::SafeBuffer.new + "Image Credit: " + sanitize(attribution, tags: allowed_tags, attributes: allowed_attributes), class: "attribution") if attribution.present?
    return content_tag(:figure, image + attribution + caption)
  end
  
  # Returns an embedded YouTube video.
  def youtube_embed(video_id)
    return content_tag(:div, class: %w(row)) do
      content_tag(:div, class: %w(col-md-6 col-sm-8 offset-md-3 offset-sm-2)) do
        content_tag(:div, class: %w(embed-responsive embed-responsive-4by3)) do
          content_tag(:iframe, nil, width: "420", height: "315", src: "https://www.youtube.com/embed/#{video_id}", frameborder: 0, allowfullscreen: true)
        end
      end
    end
  end
  
end
