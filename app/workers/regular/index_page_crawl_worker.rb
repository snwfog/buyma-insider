# Crawls an index page
class IndexPageCrawlWorker < Worker::Base
  sidekiq_options unique:                :until_and_while_executing,
                  log_duplicate_payload: true

  attr_reader :index_page
  attr_reader :merchant

  def perform(args)
    validate_args(args, -> (args) { Hash === args }, 'must be an Hash')
    validate_args(args, -> (args) { args.key?('index_page_id') }, 'must contains `index_page_id`')

    @index_page_id         = args.fetch('index_page_id')
    @use_web_cache         = !args.fetch('use_web_cache', true)
    @perform_async_parsing = args.fetch('perform_async_parsing', false)

    @index_page         = IndexPage.includes(:merchant).find(@index_page_id)
    @last_crawl_history = @index_page.crawl_histories.completed.last
    @merchant           = @index_page.merchant
    @crawl_history      = @index_page.crawl_histories.create!(status:      :inprogress,
                                                              description: "`#{@merchant.name}` [#{@index_page}]")

    logger.info "Started crawling index #{@crawl_history.description}"

    make_request
  rescue RestClient::ExceptionWithResponse => ex
    @crawl_history.update!(traffic_size_in_kb: 0.0,
                           response_headers:   ex.http_headers,
                           response_status:    ex.http_code)

    logger.debug 'Index has not been modified `%s`' % @index_page.full_url
    FileUtils::touch(@index_page.cache.path)
  rescue => ex
    if @crawl_history
      @crawl_history.aborted!
      logger.error @crawl_history.description
    end

    logger.error ex
    logger.error ex.http_headers if ex.is_a? RestClient::Exception
    logger.error ex.backtrace
  else
    if @perform_async_parsing
      logger.info "Schedule a parser for index page #{@index_page}"
      IndexPageParseWorker.perform_async(@crawl_history.id)
    else
      IndexPageParseWorker.new.perform(@crawl_history.id)
    end

    @crawl_history
  ensure
    if @crawl_history
      @crawl_history.assign_attributes(finished_at: Time.now)
      unless @crawl_history.completed? && @crawl_history.aborted?
        @crawl_history.assign_attributes(status: :aborted)
      end

      @crawl_history.save!
      logger.info 'Finished crawling `%s`' % @crawl_history.description
      logger.info JSON.pretty_generate(@crawl_history.attributes)
    end
  end

  private
  def make_request
    if (raw_response = fetch_uri(@index_page.full_url,
                                 @merchant.meta.ssl?,
                                 request_headers,
                                 cookies: @merchant.cookies))

      @crawl_history.update!(traffic_size_in_kb: raw_response.file.size / 1000.0,
                             response_headers:   raw_response.headers,
                             response_status:    raw_response.code,
                             status:             :completed)

      logger.info 'Caching index `%s` into `%s`' % [raw_response.file.path, @index_page.cache.path]
      FileUtils.cp(raw_response.file.path, @index_page.cache.path)
    end
  rescue RestClient::NotModified => ex
    logger.warn "Index `#{index_page}` has not been modified since #{index_page.cache.mtime.httpdate}"
    logger.warn ex.http_headers
  end

  def request_headers
    headers ||= @merchant.headers
    headers.merge!(cache_control_headers) if @use_web_cache # && @merchant.support_cache_control

    headers
  end

  def cache_control_headers
    cache_control_headers ||= {}

    if @last_crawl_history.try(:etag) and not @last_crawl_history.try(:weak?)
      logger.info 'Strong etag `%s` exists' % @last_crawl_history.etag
      cache_control_headers.merge!(if_none_match: @last_crawl_history.etag)
    elsif @index_page.cache.exists?
      logger.info 'Index cache `%s` exists and was modified on `%s`' % [@index_page.cache.path, @index_page.cache.mtime]
      cache_control_headers.merge!(if_modified_since: @index_page.cache.mtime.httpdate)
    end

    cache_control_headers
  end
end
