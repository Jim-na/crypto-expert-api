%w[models controllers].each do |folder| 
  require_relative "#{folder}/init"
end