$:.unshift(File.expand_path('app'))
# $:.unshift(File.expand_path('db'))

require 'buyma_insider'
require 'ostruct'

load 'no_brainer/railtie/database.rake'

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

desc 'Crawl a merchant given merchant id'
task :crawl, [:merchant_id] do |_, args|
  CrawlWorker.new.perform(args.fetch(:merchant_id))
end

namespace :db do
  # Initialize merchant from config
  desc 'Setup merchants metadata'
  task :setup do
    merchant_cfg_path = File.expand_path('../config/merchant.yml', __FILE__)
    merchant_cfg      = YAML.load_file(merchant_cfg_path)
    merchant_cfg.each_key do |merchant_name|
      merchant_datum = merchant_cfg.fetch(merchant_name) { |name| raise KeyError, "Merchant #{name} not found" }
      m              = OpenStruct.new(merchant_datum)
      merchant       = Merchant.new(id: m.id, name: m.name)
      merchant.save!
      
      metadatum = MerchantMetadatum.upsert!(merchant_datum.merge(merchant: merchant))
      
      puts "Merchant #{metadatum.name}[#{metadatum.code}] created..."
    end
  end
  
  desc 'nobrainer:drop + nobrainer:sync_schema + db:setup merchants'
  task :reset => ['nobrainer:drop', 'nobrainer:sync_schema', :setup]
  
  desc 'Create a new db patch'
  task :patch, ['name'] do |t, args|
    sh "touch ./db/patches/#{Time.now.to_s}_#{args['name']}.rb".gsub(/[-:\s]/, '_')
  end
end
