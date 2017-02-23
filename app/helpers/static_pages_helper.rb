module StaticPagesHelper
  
  # Takes one or more LinkButtons, and returns HTML for a collection of buttons.
  def link_buttons(*args)
    %Q(<div class="row button-row">#{render partial: 'link_button', collection: args, as: :button}</div>).html_safe
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
