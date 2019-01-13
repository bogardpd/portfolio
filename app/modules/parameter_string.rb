module ParameterString
  
  def self.format(text)
    return text.gsub("&amp;", "and").gsub(/['‘’"“”]/, "").parameterize
  end
end