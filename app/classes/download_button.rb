class DownloadButton < LinkButton
  include ActionView::Helpers
  
  def initialize(path)
    s3 = Aws::S3::Resource.new()
    obj = s3.bucket("pbogardcom-files").object(path)

    puts path
    if obj.exists?
      @path = obj.public_url
      @size = obj.content_length
      @icon = "filetypes/#{File.extname(@path).delete('.')}"
      @icon = "filetypes/unknown" unless Rails.application.assets.find_asset("icons/#{@icon}.png")
      @text = "<strong>#{URI.decode(File.basename(@path))}</strong> (#{number_to_human_size(@size)})"
    else
      @path = ""
      @icon = "filetypes/unknown"
      @text = "Could not find file"
      @size = 0
    end
     
  end
  
  def plain_link
    return nil if @path.blank?
    return %Q(#{link_to(URI.decode(File.basename(@path)), @path)} (#{number_to_human_size(@size)})).html_safe
  end
  
end