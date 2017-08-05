require_relative './config/application'
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
  FileList['./log/**/*.log'].each do |log_file|
    puts 'Cleaning `%s`' % log_file
    sh "cat /dev/null > #{log_file}"
  end
end

desc 'Environment'
task :environment do
  puts "Executing task for `#{ENV['RACK_ENV']}`".yellow
end

desc 'Fetch a merchant indices and cache the pages'
task :fetch, [:merchant_id] do |_, args|
  MerchantCrawlWorker.new.perform(args.fetch(:merchant_id))
end

desc 'Parse article using cached index page'
task :parse, [:index_page_id] do |_, args|
  IndexPageParseWorker.new.perform(args.fetch(:index_page_id))
end

desc 'Crawl a merchant given merchant id'
task :crawl, [:merchant_id] do |_, args|
  merchant_id = args.fetch(:merchant_id)
  merchant    = Merchant.find(merchant_id)
  merchant.index_pages.each do |index_page|
    puts 'Crawling page `%s`' % index_page.full_url
    crawl_history = IndexPageCrawlWorker.new.perform('index_page_id' => index_page.id)
    raise 'Crawl failed...' unless crawl_history.completed?
    puts 'Parsing articles...'
    crawl_history = IndexPageParseWorker.new.perform(index_page.id)
    puts 'items_count: %d, invalid_items_count: %d' % [crawl_history.items_count, crawl_history.invalid_items_count]
  end
end

namespace :db do
  # Initialize merchant from config
  desc 'Setup merchants metadata'
  task :setup do
    merchant_cfg = YAML.load_file(File.expand_path('../config/merchant.yml', __FILE__))
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
      m.index_pages.each do |index_page_path|
        IndexPage.upsert!(merchant:      merchant,
                          relative_path: index_page_path)
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
      Rake::FileList[File.expand_path('../db/patches/*.rb', __FILE__)]
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
    FileList[File.expand_path('../db/fixtures/**.yml', __FILE__)].each do |fixture_yml|
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

  desc 'Schedule job'
  task :schedule_jobs do
    OpenExchangeRatesWorker.perform_async
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
  task :setup => [:drop] do
    settings             = {}
    settings['settings'] = YAML.load_file(File.expand_path('../config/elasticsearch/settings.index.yml', __FILE__))
    settings['settings'].merge!(YAML.load_file(File.expand_path('../config/elasticsearch/settings.analysis.yml', __FILE__)))
    mappings     = FileList[File.expand_path('../config/elasticsearch/mappings/**/*.yml', __FILE__)]
    merchant_ids = YAML.load_file(File.expand_path('../config/merchant.yml', __FILE__)).values.map { |m| m['id'] }
    merchant_ids.each do |merchant_id|
      puts 'Creating index for `%s`'.yellow % merchant_id
      $elasticsearch.indices.create index: merchant_id,
                                    body:  settings
      mappings.each do |mapping_file|
        puts '+- Creating index for `%s`'.yellow % merchant_id
        mapping_setting = YAML.load_file(mapping_file)
        type            = mapping_file.pathmap('%n')
        $elasticsearch.indices.put_mapping index: merchant_id,
                                           type:  type,
                                           body:  { "#{type}": mapping_setting }
      end
    end
  end

  desc 'Index existing documents'
  task :seed do
    time = Benchmark.realtime do
      Article.eager_load(:price_history).each do |article|
        price_history      = article.price_history.attributes.except(:article_id,
                                                                     :min_price,
                                                                     :max_price)
        article_attributes = article.attributes.except(:id).merge(price_history: price_history)
        $elasticsearch.index index: article.merchant_id,
                             type:  :article,
                             id:    article.id,
                             body:  article_attributes
      end
    end
    puts 'Seeded elasticsearch in %.02fs' % time
  end

  desc 'Build config'
  task :build_all => [:build_templates, :build_stopwords, :build_char_filter_mappings]

  desc 'Build templates'
  task :build_templates do
    puts <<~SQL.yellow
      Generating search templates...
    SQL

    dest_dir        = File.expand_path('../tmp/configs/elasticsearch/config/scripts', __FILE__)
    replace_to_json = %r/"({{#toJson}}([^{]+){{\/toJson}})"/
    FileUtils.mkdir_p(dest_dir) unless Dir.exists?(dest_dir)

    FileList[File.expand_path('../config/elasticsearch/search_templates/*.yml', __FILE__)].each do |template_file|
      template_hash = YAML::load_file(template_file)
      template_name = template_file.pathmap('%n')
      printf 'Generating search template `%s`...' % template_name
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

    puts 'Copy search templates under /<es_install_location>/config/scripts'.yellow
  end

  # @deprecated Use build template and place under script template folder
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

  desc 'Build stopword lists'
  task :build_stopwords do
    puts
    puts <<~SQL.yellow
      Generating stopword lists...
      To setup the wordlists, make sure that the ./config/elasticsearch/config
      folder is properly setup whether the host machine is win or mac
      SELECT * FROM dbo.Test
    SQL

    dest_dir = File.expand_path('../tmp/configs/elasticsearch/config/stopwords', __FILE__)
    FileUtils.mkdir_p(dest_dir) unless Dir.exists?(dest_dir)

    FileList[File.expand_path('../lib/elasticsearch/wordlists/*.txt', __FILE__)].each do |wl_filename|
      filter_name = wl_filename.pathmap('%n')
      printf 'Generating stopwords `%s`...' % filter_name
      word_lists = File
                     .open(wl_filename)
                     .map(&:strip)
                     .to_a
                     .reject { |r| r.start_with?(?#) || r.empty? }
                     .uniq
                     .sort

      File.open('%s/%s.txt' % [dest_dir, filter_name], ?w) do |wordlist_file|
        wordlist_file.puts(word_lists)
      end
      puts 'Done!'.green
    end

    puts 'Copy stopwords under /<es_install_location>/config/stopwords'.yellow
  end


  desc 'Build character filter mappings'
  task :build_char_filter_mappings do
    puts
    puts 'Generating character filter mappings...'.yellow

    dest_dir = File.expand_path('../tmp/configs/elasticsearch/config/char_filter_mappings', __FILE__)
    FileUtils.mkdir_p(dest_dir) unless Dir.exists?(dest_dir)

    FileList[File.expand_path('../config/elasticsearch/char_filter_mappings/*.txt', __FILE__)].each do |char_filter_mapping|
      printf 'Generating char_filter_mapping %s...' % char_filter_mapping
      FileUtils.cp(char_filter_mapping, dest_dir + '/')
      puts 'Done!'.green
    end

    puts 'Copy character filter mappings under /<es_install_location>/config/char_filter_mappings'.yellow
  end
end
