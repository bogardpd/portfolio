module ApplicationHelper
  
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Paul Bogard’s Portfolio"
    if page_title.empty?
      base_title
    else
      page_title + " - " + base_title
    end
  end
  
  # Returns a formatted date.
  # TODO: Remove in favor of FormattedDate module throughout portfolio
  def format_date(input_date)
    input_date.strftime("%e %b %Y").strip
  end

  def show_breadcrumbs
    return "" unless @breadcrumbs && @breadcrumbs.length > 1

    breadcrumbs = @breadcrumbs[0..@breadcrumbs.length-2].map{|b| content_tag(:li, link_to(b[0], b[1]), class: "breadcrumb-item")}
    breadcrumbs << content_tag(:li, @breadcrumbs.last[0], class: %w(breadcrumb-item active))
    
    html = content_tag(:ol, safe_join(breadcrumbs), class: "breadcrumb")
    html = content_tag(:nav, html, "aria-label": "breadcrumb", class: "breadcrumb")
    
    return html
  end
  
  def link_header(text, level, subtext=nil)
    return text unless [1,2,3,4,5,6].include?(level)
    header = ActiveSupport::SafeBuffer.new
    header << text
    if subtext.present?
      header << " "
      header << content_tag(:small, subtext)
    end
    return content_tag("h#{level}".to_sym, link_to(header, params.permit(:anchor, :gallery, :page).merge(anchor: anchorize(text)), class: "link-header"), id: anchorize(text))
  end
  
  # Returns the meta description on a per-page basis.
  def meta_description(page_meta_description = '')
    if page_meta_description.empty?
      ""
    else
      "<meta name=\"description\" content=\"#{page_meta_description}\" />".html_safe
    end
  end
  
  # Format a menu link depending on whether or not it refers to the current page
  def nav_link(text, path)
     classes = %w(dropdown-item)
     classes << "active" if current_page?(path)
     return link_to(text, path, class: classes)
  end
  
  # Formats text for use in anchor/id attributes
  def anchorize(text)
    return ParameterString::format(text)
  end
  
end
