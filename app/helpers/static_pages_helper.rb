module StaticPagesHelper
  
  # Returns a responsive image.
  def project_image(image_path, alt_text='')
    html = "<div class=\"image\">"
    html += image_tag(image_path, class: 'img-responsive project', alt: alt_text)
    html += "</div>"
    html.html_safe
  end
  
end
