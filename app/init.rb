# frozen_string_literal: true

%w[domain infrastructure controllers].each do |folder|
  require_relative "#{folder}/init.rb"
end
