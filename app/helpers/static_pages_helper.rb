module StaticPagesHelper
  
  # Returns a download button with icon, filename, and filesize.
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
