source 'https://rubygems.org'


# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development, :test, :production do
  # Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
  gem 'rails', '5.0.1'
  # Use Puma as the app server
  gem 'puma'
  gem 'sass-rails', '~> 5.0'
  gem 'bootstrap-sass', '~> 3.3.6'
  gem 'uglifier', '>= 1.3.0'
  gem 'coffee-rails', '~> 4.1.0'
  gem 'jquery-rails'
  gem 'devise', '~> 4.0.3'
  gem 'kaminari', git: 'git://github.com/amatsuda/kaminari.git', branch: 'master'
  # See https://github.com/rails/execjs#readme for more supported runtimes
  gem 'therubyracer', platforms: :ruby
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'rubocop', '~> 0.39.0', require: false
end

group :test do
  gem 'simplecov', require: false
end

group :bot do
  gem 'cinch', '~> 2.3.1'
  gem 'cinch-identify', '~> 1.7.0', require: 'cinch/plugins/identify'

  gem 'json'
  gem 'activerecord', require: 'active_record'
  gem 'oauth', '~> 0.4.7'
  gem 'htmlentities'
  gem 'wunderground'
end
