# Given import folder, will import all json file
# because windows have trouble using rethinkdb restore
require 'rake'

models_dir, db, = ARGV

Rake::FileList["#{models_dir}/**/*.json"].each do |model_file|
  model_name = model_file.pathmap('%n')
  puts "Importing models #{model_name}"
  sh "rethinkdb import -f #{model_file} --table #{db}.#{model_name} --force"
end
