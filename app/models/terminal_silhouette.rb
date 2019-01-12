class TerminalSilhouette < ApplicationRecord
  ROOT_PATH = PortfolioImage::ROOT_PATH + "projects/terminal-silhouettes"
  CAP_CODES = %w( iata_code )
  
  before_save :capitalize_codes
  
  validates :iata_code, presence: true, length: { is: 3 }, uniqueness: { case_sensitive: false }
  validates :city, presence: true
  
  protected
  
  def capitalize_codes
    CAP_CODES.each { |code| self[code] = self[code].upcase }
  end
  
end
