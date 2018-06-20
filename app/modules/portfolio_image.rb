module PortfolioImage
  ROOT_PATH = "https://s3.us-east-2.amazonaws.com/pbogardcom-images/"

  def asset_exist?(path)
    if Rails.configuration.assets.compile
      Rails.application.precompiled_assets.include? path
    else
      Rails.application.assets_manifest.assets[path].present?
    end
  end
end