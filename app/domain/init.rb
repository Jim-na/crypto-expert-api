# frozen_string_literal: true

folders = %w[currencypair]
folders.each do |folder|
  require_relative "#{folder}/init"
end
