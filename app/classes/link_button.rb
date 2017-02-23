class LinkButton
  
  def initialize(text, icon, path)
    @text = text
    @icon = icon
    @path = path
  end
  
  def text
    @text
  end
  
  def icon
    "icons/#{@icon}.png"
  end
  
  def path
    @path
  end
  
end