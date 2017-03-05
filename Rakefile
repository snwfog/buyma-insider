$:.unshift(File.expand_path('app'))
# $:.unshift(File.expand_path('db'))

require 'buyma_insider'
load 'no_brainer/railtie/database.rake'

# require 'bundler'

# Bundler.require
# include RethinkDB::Shortcuts
# db_name = "#{BuymaInsider::NAME}_#{ENV.fetch('RACK_ENV')}"

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

desc 'Environment'
task :environment do
  # Just an empty task that stub rails environment task
end

namespace :db do
  # Initialize merchant from config
  desc 'Setup merchants metadata'
  task :setup do
    merchant_cfg_path = File.expand_path('../config/merchant.yml', __FILE__)
    merchant_cfg      = YAML.load_file(merchant_cfg_path)
    merchant_cfg.each_key do |k|
      merchant = MerchantMetadatum.upsert!(merchant_cfg.fetch(k))
      puts "Merchant #{merchant.name}[#{merchant.code}] created..."
    end
  end
  
  desc 'Create a new db patch'
  task :patch, ['name'] do |t, args|
    sh "touch ./db/patches/#{Time.now.to_s}_#{args['name']}.rb".gsub(/[-:\s]/, '_')
  end
end
