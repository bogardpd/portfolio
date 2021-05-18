source 'https://rubygems.org'

ruby '2.7.1'

gem 'rails', '~> 6.0', '>= 6.0.2.1'

gem 'sassc-rails', '~> 2.1', '>= 2.1.2'

# Use redcarpet for Markdown parsing.
gem 'redcarpet', '~> 3.5'

# Use AWS S3 for images and downloadable files.
gem 'aws-sdk-s3', '~> 1.81'

# Force nokogiri update for https://github.com/advisories/GHSA-vr8q-g5c7-m54m
gem 'nokogiri', '>= 1.11.0.rc4'

gem 'bcrypt'

group :development do
end

group :development, :test do
  gem 'sqlite3', '~> 1.4'
  gem 'spring'
end

group :test do
  gem 'minitest-reporters'
end

group :production do
  gem 'pg', '~> 1.2', '>= 1.2.2'
  gem 'puma', '4.3.8'
end
