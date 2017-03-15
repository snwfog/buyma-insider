$:.unshift(File.expand_path('app'))
# $:.unshift(File.expand_path('db'))

require 'dotenv/load'
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
    merchant_cfg = YAML.load_file('./config/merchant.yml')
    merchant_cfg.each_key do |merchant_name|
      merchant_datum = merchant_cfg.fetch(merchant_name)
      m              = OpenStruct.new(merchant_datum)
      merchant       = Merchant.create!(id: m.id, name: m.name)
      metadatum      = MerchantMetadatum.upsert!(id:        m.id,
                                                 merchant:  merchant,
                                                 name:      m.name,
                                                 domain:    m.domain,
                                                 pager_css: m.pager_css,
                                                 item_css:  m.item_css,
                                                 ssl:       m.ssl)
      m.index_pages.each do |idx|
        IndexPage.upsert!(merchant:      merchant,
                          relative_path: idx)
      end
    
      puts "Merchant #{metadatum.name}[#{metadatum.code}] created..."
    end
  end

  desc 'nobrainer:drop + nobrainer:sync_schema + db:setup merchants'
  task :reset => ['nobrainer:drop', 'nobrainer:sync_schema', :setup]

  desc 'Create a new db patch'
  task :create_patch_file, ['name'] do |t, args|
    touch "./db/patches/#{Time.now.to_s}_#{args.fetch(:name, 'db_patch')}.rb".gsub!(/[-:\s]/, '_')
  end

  desc 'Apply all new patches'
  task :apply_patches do
    require 'benchmark'

    include RethinkDB::Shortcuts
    r.connect(db: "buyma_insider_#{ENV['RACK_ENV']}").repl

    applied_patches = r.table('meta_db_patches')
                        .order_by('run_at')
                        .pluck('name')
                        .run
                        .collect { |p| p['name'] }

    puts 'Begin applying patches from db/patches'
    time = Benchmark.measure {
      Rake::FileList['./db/patches/*.rb']
        .exclude(/setup/)
        .delete_if { |path| applied_patches.include?(path.pathmap('%n')) }
        .each do |patch_path|
        begin
          print "Applying #{patch_path}... "
          load(patch_path)
        rescue Exception => ex
          puts 'Errored!'
          puts ex.message
        else
          r.table('meta_db_patches')
            .insert(Hash[:run_at, Time.now.iso8601, :name, patch_path.pathmap('%n')])
            .run
          puts 'Applied.'
        end
      end
    }

    puts 'Finished applying patches (%.02fs)' % time.real
  end
end

namespace :es do
  desc 'Drop index, setup elasticsearch, and sync all articles'
  task :reset => [:drop, :setup, :seed]
  
  desc 'Drop all indices'
  task :drop do
    $elasticsearch.indices.delete index: :_all
  end
  
  desc 'Create index'
  task :setup do
    es_cfg = YAML.load_file('./config/elasticsearch.yml').symbolize_keys!
    $elasticsearch.indices.create(es_cfg)
  end
  
  desc 'Index existing documents'
  task :seed do
    time = Benchmark.measure do
      Article.each do |article|
        $elasticsearch.index index: :shakura,
                             type:  :article,
                             id:    article.id,
                             body:  article.attributes.except(:id)
      end
    end
    puts 'Seed elasticsearch in %.02fs' % time.real
  end
end
