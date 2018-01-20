source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.19.0'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development, :test, :production do
  # Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
  gem 'rails', '5.1.4'
  # Use Puma as the app server
  gem 'puma'
  gem 'sass-rails', '~> 5.0'
  gem 'bootstrap-sass', '~> 3.3.7'
  gem 'uglifier', '>= 1.3.0'
  gem 'jquery-rails'
  gem 'devise', '~> 4.3.0'
  gem 'kaminari'
  # See https://github.com/rails/execjs#readme for more supported runtimes
  gem 'therubyracer', platforms: :ruby
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'rubocop', '~> 0.52.1', require: false
end

group :test do
  gem 'simplecov', require: false
  gem 'rails-controller-testing'
end

group :bot do
  gem 'cinch', '~> 2.3.2'
  gem 'cinch-identify', '~> 1.7.0', require: 'cinch/plugins/identify'

  gem 'json'
  gem 'activerecord', require: 'active_record'
  gem 'oauth', '~> 0.4.7'
  gem 'htmlentities'
  gem 'wunderground'
end
