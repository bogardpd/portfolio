module StaticPagesHelper
  
  # Returns a download hash with icon, filename, and filesize.
  def download_hash(path)
    icon = "filetypes/#{File.extname(path).delete('.')}"
    icon = "filetypes/unknown" unless Rails.application.assets.find_asset("icons/#{icon}.png")
    text = "<strong>#{File.basename(path)}</strong> (#{number_to_human_size(File.size?("public/"+path))})"
    return {text: text, icon: icon, path: path}
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
