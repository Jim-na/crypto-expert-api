# frozen_string_literal: true

%w[requests services controllers].each do |folder|
  require_relative "#{folder}/init"
end
