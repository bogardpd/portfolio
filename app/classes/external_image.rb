class ExternalImage
  AWS_S3_ROOT = "https://pbogardcom-images.s3.us-east-2.amazonaws.com/"
  
  def initialize(path)
    @path = path
  end

  def exists?
    return @exists if defined?(@exists)
    require "net/http"
    exist_url = URI.parse(url)
    req = Net::HTTP.new(exist_url.host)
    res = req.request_head(exist_url.path)
    @exists = (res.code.to_i == 200)
    return @exists
  end

  # Returns the url of the image.
  def url
    return [AWS_S3_ROOT, @path.split("/").map{|p| ERB::Util.url_encode(p)}.join("/")].join()
  end

  def credit
    require "open-uri"
    return nil unless self.exists?
    return @credit if defined?(@credit)
    credit_path = AWS_S3_ROOT + @path.gsub(/.jpg$/, ".credit.txt")
    begin
      @credit = URI.open(credit_path).read.strip
    rescue OpenURI::HTTPError
      @credit = nil
    end
    return @credit
  end

end