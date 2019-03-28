source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'jbuilder', '~> 2.5'
gem 'octokit', '~> 4.0'
gem 'puma', '~> 3.12'
gem 'rails', '~> 5.2.3'

group :development do
  gem 'web-console', '>= 3.3.0'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'rubocop'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver', '~> 3.7'
  gem 'webdrivers', '~> 3.0'
  gem 'webmock', '~> 3.0'
end
