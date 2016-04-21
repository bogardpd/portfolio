module StaticPagesHelper
  
  # Returns a responsive image.
  def project_image(image_path, alt_text='', ios_screenshot=false)
    html = "<div class=\"image\">"
    if ios_screenshot
      html += image_tag(image_path, class: 'img-responsive project ios-screenshot', alt: alt_text)
    else
      html += image_tag(image_path, class: 'img-responsive project', alt: alt_text)
    end
    html += "</div>"
    html.html_safe
  end
  
end
