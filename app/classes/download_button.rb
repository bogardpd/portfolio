class DownloadButton < LinkButton
  include ActionView::Helpers
  
  def initialize(path)
    @path = path
    @icon = "filetypes/#{File.extname(@path).delete('.')}"
    @icon = "filetypes/unknown" unless Rails.application.assets.find_asset("icons/#{@icon}.png")
    @text = "<strong>#{File.basename(@path)}</strong> (#{number_to_human_size(File.size?("public/"+@path))})"
  end
  
end