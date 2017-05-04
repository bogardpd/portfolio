module StaticPagesHelper
  
  # Takes one or more LinkButtons, and returns HTML for a collection of buttons.
  def link_buttons(*args)
    %Q(<div class="row button-row">#{render partial: 'link_button', collection: args, as: :button}</div>).html_safe
  end
  
  # Returns a responsive image.
  def project_image(path, type: nil, alt: nil, caption: nil, attribution: nil)
    classes = %w(img-responsive project)
    extra_classes = {
      :ios_screenshot => %w(ios-screenshot),
      :screenshot     => %w(screenshot)
    }
    classes.concat(extra_classes[type]) if extra_classes[type]
    path = "https://s3.us-east-2.amazonaws.com/pbogardcom-images/#{path}"
    image = image_tag(path, class: classes.join(' '), alt: alt)
    image = link_to(image, image_path(path)) if type == :screenshot
    caption = "<figcaption>#{caption}</figcaption>" if caption.present?
    attribution = %Q(<figcaption class="attribution">Image Credit: #{attribution}</figcaption>) if attribution.present?
    return %Q(<figure>#{image}#{attribution}#{caption}</figure>).html_safe
  end
  
  # Returns an embedded YouTube video.
  def youtube_embed(video_id)
    html = "<div class=\"row\">"
    html += "<div class=\"col-md-6 col-sm-8 col-md-offset-3 col-sm-offset-2\">"
    html += "<div class=\"embed-responsive embed-responsive-4by3\">"
    html += "<iframe width=\"420\" height=\"315\" src=\"https://www.youtube.com/embed/#{video_id}\" frameborder=\"0\" allowfullscreen></iframe>"
    html += "</div></div></div>"
    html.html_safe
  end
  
end
