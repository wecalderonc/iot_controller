source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'

# Dry-Gems
gem 'dry-auto_inject'
gem 'dry-validation'
gem 'dry-transaction'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Handle secrets per environment
gem "figaro"

#workers
gem 'sidekiq'
gem 'rufus-scheduler', '~> 3.4.0'
gem 'sidekiq-cron'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Quality Assurance Tools
  gem 'rails_best_practices'
  gem 'brakeman'
  gem 'rubycritic', require: false
  gem "capistrano", "~> 3.11", require: false
end

group :test do
  gem 'rspec-rails'
  gem 'rails-controller-testing'
  gem 'vcr'
  gem 'timecop'
  gem 'faker'
  gem 'simplecov', require: false
  gem 'simplecov-console', require: false
  gem 'sqlite3'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
