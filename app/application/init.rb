# frozen_string_literal: true

%w[requests services controllers forms].each do |folder|
  require_relative "#{folder}/init"
end
