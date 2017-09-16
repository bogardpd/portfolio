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
  
  def link_header(text, level)
    %Q(<h#{level} id="#{text.parameterize}">#{link_to(text.html_safe, params.merge(anchor: text.gsub("&amp;", "and").parameterize), class: "link-header")}</h#{level}>).html_safe
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
       html = "<li>#{link_to(text, path, class: 'selected')}</li>"
     else
       html = "<li>#{link_to(text, path)}</li>"
     end
     html.html_safe
  end
  
end
