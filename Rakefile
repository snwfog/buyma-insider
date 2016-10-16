%w(app config spec workers).each do |p|
  $LOAD_PATH.unshift(File.expand_path(p), File.dirname(__FILE__))
end

require 'nobrainer'
# require 'bundler'
# require 'buyma_insider'

# Bundler.require
# include RethinkDB::Shortcuts
# db_name = "#{BuymaInsider::NAME}_#{BuymaInsider::ENVIRONMENT}"

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
