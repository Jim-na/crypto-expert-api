# frozen_string_literal: true

%w[controllers forms services].each do |folder|
  require_relative "#{folder}/init"
end
