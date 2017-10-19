source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.1'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'devise'
gem 'redis', '~> 3.0'
gem 'kaminari'
gem 'carrierwave', '~> 1.0'
gem "mini_magick"
gem 'active_interaction', '~> 3.5'
gem 'globalize', github: 'globalize/globalize'
gem 'activemodel-serializers-xml'

gem 'sidekiq'
gem 'sinatra', github: 'sinatra/sinatra'

gem 'sass-rails', '~> 5.0'
gem 'coffee-rails', '~> 4.2'
gem 'uglifier', '>= 1.3.0'
gem 'bootstrap-sass', '~> 3.3.7'
gem "font-awesome-rails"
gem 'jquery-rails'
gem 'jquery-validation-rails'
gem 'jquery_mask_rails'

# gem 'therubyracer', platforms: :ruby
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

group :production do
  gem 'fog'
  gem 'rails_12factor'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano-rails'
end

group :test do
  gem 'rspec-rails'
  gem 'capybara-selenium'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
end
