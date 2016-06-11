class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  
  has_secure_password
end
