# frozen_string_literal: true

folders = %w[currencypair signal]
folders.each do |folder|
  require_relative "#{folder}/init"
end
