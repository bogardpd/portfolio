module MarkdownText

  WHITELISTS = {
    nil => {
      tags: %w(a em p span strong),
      attributes: %w(href target)
    },
    computer_supplemental: {
      tags: %w(a span),
      attributes: %w(class href target)
    }
  }

  # Returns a Redcarpet Markdown object.
  def self.markdown
    renderer = Redcarpet::Render::HTML.new(link_attributes: {target: :_blank})
    markdown = Redcarpet::Markdown.new(renderer)
  end

  # Parses a Markdown string to HTML.
  def self.parse(text, format: nil)
    return "" unless text
    whitelist = WHITELISTS[format]
    output = ActionController::Base.helpers.sanitize(self.markdown.render(text), **whitelist)
    return output
  end

end