# Crawls an index page
class IndexPageCrawlWorker < Worker::Base
  sidekiq_options unique:                :until_and_while_executing,
                  log_duplicate_payload: true

  attr_reader :standard_headers
  attr_reader :index_page
  attr_reader :merchant
  attr_reader :merchant_cache_dir

  def initialize
    @standard_headers = {
      x_forwarded_for:  Faker::Internet.ip_v4_address,
      x_forwarded_host: Faker::Internet.ip_v4_address,
      user_agent:       BuymaInsider::SPOOF_USER_AGENT,
      accept_encoding:  'gzip',
      cache_control:    'no-cache',
      pragma:           'no-cache'
    }
  end

  def perform(args)
    validate_args(args, -> (args) { Hash === args }, 'must be an Hash')
    validate_args(args, -> (args) { args.key?('index_page_id') }, 'must contains `index_page_id`')

    index_page_id       = args.fetch('index_page_id')
    is_lazy             = !args.fetch('no_cache', false)
    is_schedule_parser  = args.fetch('schedule_parser', false)
    @index_page         = IndexPage.eager_load(:merchant).find(index_page_id)
    @last_crawl_history = @index_page.crawl_histories.finished.first
    @merchant           = @index_page.merchant
    @merchant_cache_dir = File.expand_path(BuymaInsider.root + "/tmp/cache/crawl/#{@merchant.id}")
    FileUtils::mkdir_p(@merchant_cache_dir) unless File::directory?(@merchant_cache_dir)

    @standard_headers.merge(lazy_headers) if is_lazy
    @current_crawl_history = CrawlHistory.create!(index_page:  @index_page,
                                                  status:      :inprogress,
                                                  description: "#{@merchant.name} [#{@index_page}]")
    logger.info 'Started crawling index `%s`' % @current_crawl_history.description
    if raw_resp_tempfile = fetch_page_with_capture(@index_page.full_url,
                                                   @merchant.meta.ssl?,
                                                   @standard_headers)
      @current_crawl_history.update!(traffic_size_in_kb: raw_resp_tempfile.file.size / 1000.0,
                                     response_headers:   raw_resp_tempfile.headers.to_h,
                                     response_status:    :ok,
                                     status:             :completed)
      logger.info 'Caching index `%s` into `%s`' % [raw_resp_tempfile.file.path, @index_page.cache_html_path]
      FileUtils.cp(raw_resp_tempfile.file.path, @index_page.cache_html_path)
    end
  rescue RestClient::NotModified
    @current_crawl_history.update!(traffic_size_in_kb: 0.0,
                                   response_headers:   @last_crawl_history.response_headers,
                                   response_status:    :not_modified)

    logger.debug 'Index has not been modified `%s`' % @index_page.full_url
    FileUtils::touch(@index_page.cache_html_path)
  rescue Exception => ex
    if @current_crawl_history
      @current_crawl_history.aborted!
      logger.error @current_crawl_history.description
    end

    logger.error ex
    logger.error ex.http_headers if ex.is_a? RestClient::Exception
    logger.error ex.backtrace
  else
    if is_schedule_parser
      logger.info 'Scheduling an index page parser'
      IndexPageParseWorker.perform_async(index_page_id)
    end
    
    @current_crawl_history
  ensure
    if @current_crawl_history
      @current_crawl_history.finished_at = Time.now
      @current_crawl_history.save!
      logger.info 'Finished crawling `%s`' % @current_crawl_history.description
      logger.info JSON.pretty_generate(@current_crawl_history.attributes)
    end
  end

  private

  def lazy_headers
    if @last_crawl_history&.etag and not @last_crawl_history&.weak?
      logger.info 'Strong etag `%s` exists' % @last_crawl_history.etag
      { if_none_match: @last_crawl_history.etag }
    elsif File::exist?(@index_page.cache_html_path)
      index_page_cache_file_mtime = File::mtime(@index_page.cache_html_path)
      logger.info 'Index cache `%s` exists and was modified on `%s`' % [@index_page.cache_html_path, index_page_cache_file_mtime]
      { if_modified_since: index_page_cache_file_mtime.httpdate }
    else
      {}
    end
  end
end
