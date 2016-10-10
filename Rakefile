%w(lib config spec workers).each do |p|
  $:.unshift(File.expand_path(p), File.dirname(__FILE__))
end

require 'nobrainer'
# require 'bundler'
# require 'buyma_insider'

# Bundler.require
# include RethinkDB::Shortcuts
# db_name = "#{BuymaInsider::NAME}_#{BuymaInsider::ENVIRONMENT}"

desc 'Start sidekiq'
task :sidekiq do
  sh 'bundle execute sidekiq -r ./workers/buyma_insider_worker.rb'
end

desc 'Run test'
task :test do
  sh 'pry -Iworkers:lib:spec ./spec/*_spec.rb'
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
  desc 'Recreate the database'
  task :reset => :drop do
    NoBrainer.sync_schema(verbose: true)
  end

  desc 'Sync the schema and tables'
  task :drop do
    puts "DROPPING #{db_name}"
    NoBrainer.purge!
  end
end
