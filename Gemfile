source 'https://rubygems.org'

ruby '2.3.1'

gem 'rails', '5.0.0.1'

gem 'bootstrap', '~> 4.1', '>= 4.1.3'
gem 'sassc', '~> 1.12', '>= 1.12.1'

gem 'bcrypt'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'aws-sdk', '~> 2'

# Force loofah to 2.2.1 for security update.
# https://github.com/flavorjones/loofah/issues/144
gem 'loofah', '~> 2.2.1'

group :development do
  gem 'web-console', '~> 2.0'
end

group :development, :test do
  gem 'sqlite3', '1.3.9'
  gem 'byebug'
  gem 'spring'
end

group :test do
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'mini_backtrace', '0.1.3'
  gem 'guard-minitest', '2.3.1'
end

group :production do
  gem 'pg', '~> 0.18.4'
  gem 'rails_12factor', '0.0.2'
  gem 'puma', '3.9.1'
end
