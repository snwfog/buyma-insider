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
task :log_clean do
  rm_rf './log/*.log'
end

desc 'Environment'
task :environment do
  puts "Executing task for `#{ENV['RACK_ENV']}`".yellow
end

desc 'Fetch a merchant indices and cache the pages'
task :fetch, [:merchant_id] do |_, args|
  CrawlWorker.new.perform(args.fetch(:merchant_id))
end

desc 'Parse article using cached '
task :parse, [:crawl_history_id] do |_, args|
  ArticleParseWorker.new.perform(args.fetch(:crawl_history_id))
end

desc 'Crawl a merchant given merchant id'
task :crawl, [:merchant_id] => [:fetch] do |_, args|
  CrawlSession.order_by(created_at: :desc).first.tap do |crawl_session|
    crawl_session.crawl_histories.each do |crawl_history|
      puts 'Parsing articles for index `%s`' % crawl_history.description
      ArticleParseWorker.new.perform(crawl_history.id)
    end
  end
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

      puts 'Merchant %20s[%s] created...' % [metadatum.name, metadatum.code]
    end
  end

  desc 'nobrainer:drop + nobrainer:sync_schema + db:setup merchants'
  task :reset => ['nobrainer:drop', 'nobrainer:sync_schema', :setup, :seed]

  desc 'Create a new db patch'
  task :patch_generate, ['name'] do |t, args|
    touch "./db/patches/#{Time.now.to_s}_#{args.fetch(:name, 'db_patch')}.rb".gsub!(/[-:\s]/, '_')
  end

  desc 'Apply all new patches'
  task :patch_apply do
    require 'benchmark'

    include RethinkDB::Shortcuts
    r.connect(db: "buyma_insider_#{ENV['RACK_ENV']}").repl

    unless r.table_list().run.include?('meta_db_patches')
      raise '`meta_db_patches` table not found'.red
    end

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
          puts
          puts 'Error applying patch. Execution is terminated. Subsequent patches are not applied.'.red
          puts ex.message
          exit
        else
          r.table('meta_db_patches')
            .insert(Hash[:run_at, Time.now.iso8601, :name, patch_path.pathmap('%n')])
            .run
          puts 'Applied.'.green
        end
      end
    }

    puts 'Finished applying patches (%.02fs)' % time.real
  end
  
  desc 'Seed'
  task :seed do
    FileList['./db/fixtures/**.yml'].each do |fixture_yml|
      printf 'Importing %s...' % fixture_yml
      fixtures   = YAML::load_file(fixture_yml)
      class_name = fixture_yml.pathmap('%n').singularize.classify
      unless Object.const_defined? class_name
        puts ('Could not find class `%s`' % class_name).red
        next
      end
      klazz = class_name.safe_constantize
      YAML::load_stream(File.read(fixture_yml)) do |hash|
        fixture_model = klazz.new(hash)
        if fixture_model.valid?
          fixture_model.save!
        else
          puts fixture_model.errors.full_messages.join('\n').red
        end
      end
      puts 'Done.'.green
    end
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
    dir                  = './config/elasticsearch'
    settings             = {}
    settings['settings'] = YAML.load_file('%s/settings.index.yml' % dir)
    settings['settings'].merge!(YAML.load_file('%s/settings.analysis.yml' % dir))
    settings.merge!(YAML.load_file('%s/mappings.yml' % dir))
    merchant_ids = YAML.load_file('./config/merchant.yml').values.map { |m| m['id'] }
    # pp settings
    merchant_ids.each do |m_id|
      puts 'Creating index for `%s`'.yellow % m_id
      $elasticsearch.indices.create index: m_id,
                                    body:  settings
    end
  end
  
  desc 'Index existing documents'
  task :seed do
    time = Benchmark.realtime do
      Article.each do |article|
        $elasticsearch.index index: article.merchant_id,
                             type:  :article,
                             id:    article.id,
                             body:  article.attributes.except(:id)
      end
    end
    puts 'Seeded elasticsearch in %.02fs' % time
  end

  desc 'Build templates'
  task :build_templates do
    puts <<~SQL.yellow
      Setup the templates for the queries
    SQL
  
    dest_dir        = './config/elasticsearch/config/scripts'
    replace_to_json = /"({{#toJson}}([^{]+){{\/toJson}})"/
  
    FileList['./config/elasticsearch/config/templates/*.yml'].each do |template_file|
      template_hash = YAML::load_file(template_file)
      template_name = template_file.pathmap('%n')
      printf 'Generating template file `%s`...' % template_name
      File.open('%s/%s_search.mustache' % [dest_dir, template_name], ?w) do |mustache_file|
        json_str = JSON.pretty_generate(template_hash)
        if json_str =~ replace_to_json
          json_str.gsub!(replace_to_json, '\1')
        end
        
        mustache_file.write(json_str)
        mustache_file.flush
      end
      puts 'Done!'.green
    end
  end
  
  desc 'Register templates'
  task :register_templates do
    puts 'Registering templates'.yellow
    
    FileList['./config/elasticsearch/config/templates/*.yml'].each do |template_file|
      template_name = template_file.pathmap('%n')
      puts 'Registering `%s_search`...'.yellow % template_name
      template_hash = YAML::load_file(template_file)
      $elasticsearch.put_template id:   "#{template_name}_search",
                                  body: { template: template_hash }
      puts 'Done!'.green
    end
  end
  
  desc 'Build filters'
  task :build_filters do
    puts <<~SQL.yellow
      To setup the wordlists, make sure that the ./config/elasticsearch/config
      folder is properly setup whether the host machine is win or mac
      SELECT * FROM dbo.Test
    SQL
    FileList['./lib/elasticsearch/wordlists/*.txt'].each do |wl_filename|
      filter_name = wl_filename.pathmap('%n')
      printf 'Generating stopwords file `%s`...' % filter_name
      word_lists = File
                     .open(wl_filename)
                     .map(&:strip)
                     .to_a
                     .reject { |r| r.start_with?(?#) || r.empty? }
                     .uniq
                     .sort
    
      dir = './config/elasticsearch/config/stopwords'
      File.open('%s/%s.txt' % [dir, filter_name], ?w) do |wordlist_file|
        wordlist_file.puts(word_lists)
      end
    
      # File.open("./config/elasticsearch/filters/#{filter_name}_stop_filter.yml", 'w') do |filter_file|
      #   filter_file.puts('# Generated from `%s` on `%s`' % [wl_filename, Time.now.strftime('%F %H:%M')])
      #   filter_file.puts(YAML::dump("#{filter_name}_stop_filter" => { 'type'      => 'stop',
      #                                                                 'stopwords' => word_lists }))
      # end
      puts 'Done!'.green
    end
  end
  
  desc 'Test'
  task :test do
  end
end
