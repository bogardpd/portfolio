module VlogVideoHelper
  
  def format_details(details)
    # Accepts an array of details from VlogVideo.tags and returns a string of details
    return nil if details.empty?
    formatted_details = details.join(" · ");
    return content_tag(:p, formatted_details, class: "details")
  end
  
  def format_tags(tags)
    # Accepts a tag hash from VlogVideo.tags and returns a formatted list of tags
    return nil if tags.empty?

    content_tag :p, class: "tags" do
      tags.collect{|t| concat(link_to(t[:name], show_vlog_video_tag_path(t[:parameterized_name]), class: ["badge", "badge-pill", "badge-theme-inverse"]))}
    end
    
  end

end
