# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# Configuration and Utilities
gem 'figaro', '~> 1.2'
gem 'rack-test' # for testing and can also be used to diagnose in production
gem 'rake'

# PRESENTATION LAYER
gem 'multi_json', '~> 1.15'
gem 'roar', '~> 1.1'

group :production do
  gem 'pg'
end

# Database
gem 'hirb', '~> 0'
gem 'hirb-unicode', '~> 0'
gem 'sequel', '~> 5.49'

group :development, :test do
  gem 'sqlite3', '~> 1.4'
end

# Web Application
gem 'puma', '~> 5.5'
gem 'roda', '~> 3.49'
gem 'slim', '~> 4.1'

# Controllers and services
gem 'dry-monads', '~> 1.4'
gem 'dry-transaction', '~> 0.13'
gem 'dry-validation', '~> 1.7'

# Caching
gem 'rack-cache', '~> 1.13'
gem 'redis', '~> 4.5'
gem 'redis-rack-cache', '~> 2.2'

# Validation
gem 'dry-struct', '~> 1.4'
gem 'dry-types', '~> 1.5'

# Networking
gem 'http', '~> 5.0'
gem 'openssl'

# TESTING
group :test do
  gem 'minitest', '~> 5.0'
  gem 'minitest-rg', '~> 5.0'
  gem 'simplecov', '~> 0'
  gem 'vcr', '~> 6.0'
  gem 'webmock', '~> 3.0'

  gem 'headless', '~> 2.3'
  gem 'page-object', '~> 2.3'
  gem 'watir', '~> 7.0'
  gem 'webdrivers', '~> 5.0'
end

# Debugging
gem 'pry'

# Code Quality
gem 'flog'
gem 'reek'
gem 'rubocop'
