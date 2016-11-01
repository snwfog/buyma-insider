$:.unshift(File.expand_path('app'))
$:.unshift(File.expand_path('config'))
$:.unshift(File.expand_path('db'))

require 'yaml'
require 'nobrainer'
# require 'bundler'
require 'buyma_insider'

# Bundler.require
# include RethinkDB::Shortcuts
# db_name = "#{BuymaInsider::NAME}_#{BuymaInsider::ENVIRONMENT}"

desc 'Clean up config'
task :align do
  sh 'align ./config/**/*.yml'
end

desc 'Run test'
task :test do
  sh 'pry -Iapp:spec ./spec/*_spec.rb'
end

desc 'Setup ssh'
task :ssh do
  # sh 'ANYBAR_PORT=1735 open -na AnyBar'
  # sh 'ANYBAR_PORT=1736 open -na AnyBar'
  # sh 'ANYBAR_PORT=1737 open -na AnyBar'
  #
  # AnyBar::Client.new(1735).color = 'green'
  # AnyBar::Client.new(1736).color = 'green'
  # AnyBar::Client.new(1737).color = 'green'
end

desc 'Cleanup log'
task :cleanup do
  %x(rm -rf ./log/*.log)
end

namespace :db do
  # Initialize merchants from config
  desc 'Setup merchant class'
  task :setup do
    config = YAML.load_file(File.expand_path('../config/merchant.yml', __FILE__))
    config.each_key do |k|
      merchant = MerchantMetadata.upsert!(config[k])
      puts "Created #{merchant.class}[#{merchant.code}]"
    end
  end
  
  desc 'Recreate the database'
  task :reset => :drop do
    NoBrainer.sync_schema(verbose: true)
  end
  
  desc 'Sync the schema and tables'
  task :drop do
    puts "DROPPING #{db_name}"
    NoBrainer.purge!
  end
  
  desc 'Create a new db patch'
  task :patch, ['name'] do |t, args|
    sh 'touch ' + "./patches/#{Time.now.to_s}_#{args['name']}.rb".gsub(/[-:\s]/, '_')
  end
end
