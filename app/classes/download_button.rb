class DownloadButton < LinkButton
  include ActionView::Helpers
  
  def initialize(path)
    client = Aws::S3::Client.new(region: "us-east-2")
    s3 = Aws::S3::Resource.new(client: client)
    obj = s3.bucket("pbogardcom-files").object(path)

    if obj.exists?
      @path = obj.public_url
      @size = obj.content_length
      @icon = "filetypes/#{File.extname(@path).delete('.')}"
      @icon = "filetypes/unknown" unless PortfolioImage.asset_exist?("icons/#{@icon}.png")
      @text = "<strong>#{URI.decode(File.basename(@path))}</strong> (#{number_to_human_size(@size)})"
    else
      set_file_not_found_values
    end
    
  rescue Aws::Errors::NoSuchEndpointError
    set_file_not_found_values
     
  end
  
  def plain_link
    return nil if @path.blank?
    return link_to(URI.decode(File.basename(@path)), @path) + " (#{number_to_human_size(@size)})"
  end
  
  private
  
  def set_file_not_found_values
    @path = ""
    @icon = "filetypes/unknown"
    @text = "Could not find file"
    @size = 0
  end
  
end