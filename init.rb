# frozen_string_literal: true

require_relative 'app/models/init'

%w[config app].each do |folder| 
  require_relative "#{folder}/init"
end