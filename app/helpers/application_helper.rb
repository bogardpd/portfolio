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
    header = text
    header += " <small>#{subtext}</small>" if subtext.present?
    %Q(<h#{level} id="#{anchorize(text)}">#{link_to(header.html_safe, params.permit(:anchor, :gallery, :page).merge(anchor: anchorize(text)), class: "link-header")}</h#{level}>).html_safe
  end
  
  # Returns the meta description on a per-page basis.
  def meta_description(page_meta_description = '')
    if page_meta_description.empty?
      ""
    else
      "<meta name=\"description\" content=\"#{page_meta_description}\" />".html_safe
    end
  end
  
  # Return a div if this link is the current page, and a link otherwise
  def nav_link(text, path)
     if current_page?(path)
       html = link_to(text, path, class: 'dropdown-item active')
     else
       html = link_to(text, path, class: 'dropdown-item')
     end
     html.html_safe
  end
  
  # Formats text for use in anchor/id attributes
  def anchorize(text)
    return ParameterString::format(text)
  end
  
end
