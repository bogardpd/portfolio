class LinkButton
  
  def initialize(text, icon, path, target: nil)
    @text = text
    @icon = icon
    @path = path
    @target = target
  end
  
  def text
    @text
  end
  
  def icon
    @icon.present? ? "icons/#{@icon}.png" : nil
  end
  
  def path
    @path
  end
  
  def target
    @target
  end
  
end