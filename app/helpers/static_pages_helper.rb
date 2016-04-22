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
  
  def download_link(path)
    extension = File.extname(path).delete('.')
    image_location = "file-icons/" + extension + ".png"
    if Rails.application.assets.find_asset(image_location)
      image_html = image_tag(image_location, class: "icon-button") + " "
    else
      image_html = nil
    end
    link_to("#{image_html}<strong>#{File.basename(path)}</strong> (#{number_to_human_size(File.size?("public/"+path))})".html_safe, path, class: "btn btn-default btn-block icon-button", role: "button")
  end
  
end
