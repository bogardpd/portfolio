class StaticPagesController < ApplicationController
  
  def home
  end
  
  def letsencrypt
    render plain: ENV["LETS_ENCRYPT_KEY"]
  end
  
end