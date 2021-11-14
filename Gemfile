# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip
# Configuration and Utilities
gem 'figaro', '~> 1.2'
gem 'rake'

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

# Validation
gem 'dry-struct', '~> 1.4'
gem 'dry-types', '~> 1.5'

# Networking
gem 'http', '~> 5.0'
gem 'openssl'

# Testing
gem 'minitest', '~> 5.0'
gem 'minitest-rg', '~> 5.0'
gem 'simplecov', '~> 0'
gem 'vcr', '~> 6.0'
gem 'webmock', '~> 3.0'


# Debugging
gem 'pry'

# Code Quality
gem 'flog'
gem 'reek'
gem 'rubocop'
