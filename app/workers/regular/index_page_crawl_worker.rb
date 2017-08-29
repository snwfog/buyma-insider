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

    index_page_id         = args.fetch('index_page_id')
    use_web_cache         = !args.fetch('use_web_cache', true)
    perform_async_parsing = args.fetch('perform_async_parsing', false)

    @index_page         = IndexPage.includes(:merchant).find(index_page_id)
    @last_crawl_history = @index_page.crawl_histories.completed.take
    @merchant           = @index_page.merchant
    @standard_headers.merge(http_cache_headers) if use_web_cache
    @current_crawl_history = @index_page.crawl_histories.create(status:      :inprogress,
                                                                description: "#{@merchant.name} [#{@index_page}]")
    logger.info 'Started crawling index `%s`' % @current_crawl_history.description

    slack_notify(text: ":spider_web: *Crawl Started*\n#{@index_page.full_url}", unfurl_links: true)

    if raw_response = fetch_uri(@index_page.full_url, @merchant.meta.ssl?, @standard_headers)
      @current_crawl_history.update!(traffic_size_in_kb: raw_response.file.size / 1000.0,
                                     response_headers:   raw_response.headers.to_h,
                                     response_status:    :ok,
                                     status:             :completed)
      logger.info 'Caching index `%s` into `%s`' % [raw_response.file.path, @index_page.cache_html_path]
      FileUtils.cp(raw_response.file.path, @index_page.cache_html_path)
    end
  rescue RestClient::ExceptionWithResponse => ex
    @current_crawl_history.update!(traffic_size_in_kb: 0.0,
                                   response_headers:   ex.http_headers,
                                   response_status:    ex.http_code)

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
    if perform_async_parsing
      logger.info "Schedule a parser for index page #{@index_page}"
      IndexPageParseWorker.perform_async(@current_crawl_history.id)
    else
      IndexPageParseWorker.new.perform(@current_crawl_history.id)
    end

    @current_crawl_history
  ensure
    if @current_crawl_history
      @current_crawl_history.update!(finished_at: Time.now)
      logger.info 'Finished crawling `%s`' % @current_crawl_history.description
      logger.info JSON.pretty_generate(@current_crawl_history.attributes)
    end

    slack_notify(text:        ':spider_web: *Crawl Ended*',
                 attachments: [{ text:   @index_page.full_url,
                                 fields: [{ title: 'HTTP Status',
                                            value: @current_crawl_history.response_status,
                                            short: true },
                                          { title: 'Crawl Status',
                                            value: @current_crawl_history.status,
                                            short: true },
                                          { title: 'Elapsed Time',
                                            value: "#{@current_crawl_history.elapsed_time_in_s} s",
                                            short: true },
                                          { title: 'Traffic Size',
                                            value: "#{@current_crawl_history.traffic_size_in_kb} kb",
                                            short: true },
                                          { title: 'Article Total',
                                            value: @current_crawl_history.article_count,
                                            short: true }] }])
  end

  private
  def http_cache_headers
    if @last_crawl_history.try(:etag) and not @last_crawl_history.try(:weak?)
      logger.info 'Strong etag `%s` exists' % @last_crawl_history.etag
      { if_none_match: @last_crawl_history.etag }
    elsif @index_page.is_cache_exists?
      logger.info 'Index cache `%s` exists and was modified on `%s`' % [@index_page.cache_html_path, @index_page.cache_mtime]
      { if_modified_since: @index_page.cache_mtime.httpdate }
    else
      {}
    end
  end
end
