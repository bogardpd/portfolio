module Project

  include ActionView

  # Returns a hash of projects.
  def self.all
    return YAML.load_file("app/data/projects.yml").deep_symbolize_keys
  end

  # Returns a hash of tags.
  def self.all_tags
    return YAML.load_file("app/data/project_tags.yml").deep_symbolize_keys.sort.to_h
  end
  
  # Takes a project key and generates a cover image path string.
  def self.image_path(project_key)
    img_root = "projects/covers/#{project_key.to_s}"
    img_path = PortfolioImage.asset_exist?("#{img_root}.png") ? "#{img_root}.png" : "#{img_root}.jpg"
    return ActionController::Base.helpers.image_path(img_path)
  end
  
  # Takes a project key and generates a path string.
  def self.path_string(project_key)
    return "#{project_key.to_s.underscore}_path"
  end

  # Takes a project key and returns a hash of its tags.
  def self.tags(project_key)
    project_tags = self.all[project_key][:tags].map{|tag| tag.to_sym}
    return self.all_tags.slice(*project_tags)
  end
  
end