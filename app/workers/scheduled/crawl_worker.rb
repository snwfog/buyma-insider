require 'set'
require 'faker'
require 'sentry-raven'

class CrawlWorker < Worker::Base
  attr_accessor :merchant
  attr_accessor :crawl_session

  def initialize
    super

    @url_cache   = Set.new
    @histories   = []
    @std_headers = {
      x_forwarded_for:  Faker::Internet.ip_v4_address,
      x_forwarded_host: Faker::Internet.ip_v4_address,
      user_agent:       BuymaInsider::SPOOF_USER_AGENT,
      accept_encoding:  'gzip, deflate',
      cache_control:    'no-cache',
      pragma:           'no-cache'
    }
  end

  def perform(merchant_id)
    @merchant = Merchant.find!(merchant_id)
    Raven.capture do
      log_start

      crawl

      log_end
    end
  end

  def crawl
    @crawl_session = CrawlSession.create!(merchant: merchant)

    merchant.index_pages.each do |index_page|
      history = CrawlHistory.create!(
        index_page:    index_page,
        crawl_session: crawl_session,
        description:   "#{merchant.name} '#{index_page}'"
      )

      begin
        logger.info { '%s started at %s' % [history.description, Time.now] }
        history.inprogress!
        history.save!

        logger.info { "Requesting page `#{index_page}`" }

        # Add url to cache, break if already exists
        next unless @url_cache.add? index_page

        # Get link HTML and set @response if not in url cache
        response = RestClient.get index_page.full_url, @std_headers

        logger.info { 'Received html `%s` (%s} B)' % [index_page, response.content_length] }

        # Parse into document from response
        next if response.body.empty?

        document = Nokogiri::HTML(response.body)
        document.css(merchant.metadatum.item_css).each do |it|
          begin
            attrs   = merchant.attrs_from_node(it)
            article = Article.upsert!(attrs.merge(merchant:   merchant,
                                                  # Bust the serializer cache and touch the record
                                                  updated_at: Time.now.utc.iso8601))
  
            ArticleUpdatedWorker.perform_async(article.id)
            CrawlSessionArticle.create!(crawl_session: @crawl_session,
                                        article:       article)
            article.update_price_history!
            history.items_count += 1
          rescue Exception => ex
            history.invalid_items_count += 1

            logger.warn { 'Failed creating article: %s' % ex.message }
            logger.warn { attrs }
            logger.debug { it.to_html }
          else
            logger.info { '%s upserted' % article.id }
          ensure
            # logger.debug { attrs }
          end
        end

        history.traffic_size_kb += (response.content_length / 1000.0)
      rescue Exception => ex
        history.aborted!
        # raise ex swallow error and log to sentry
        Raven.capture_exception(ex)
        logger.error history.description
        logger.error ex
        if ex.is_a? RestClient::Exception
          logger.error ex.http_headers
        end
        logger.error ex.backtrace
      else
        history.completed!
      ensure
        history.finished_at = Time.now.utc.iso8601
        history.save!

        logger.info { 'Crawling %s finished at %s' % [history.description, Time.now] }
        logger.info { history.attributes }
      end
    end
  ensure
    @crawl_session.finished_at = Time.now.utc.iso8601
    @crawl_session.save!
  end

  def total_elapsed_time
    crawl_session.elapsed_time_s
  end

  def stats
    crawl_session.crawl_histories.group_by(&:completed?)
  end

  def log_start
    logger.info { 'Start crawling %s...' % merchant.name }
    Slackiq.notify webhook_name: :worker,
                   title:        "#{merchant.name} crawl started..."
  end

  def log_end
    logger.info { 'Finished crawling %s...' % merchant.name }
    Slackiq.notify webhook_name: :worker,
                   title:        "#{merchant.name} crawl finished in #{'%.02f' % (total_elapsed_time / 60)}m.",
                   success:      stats.fetch(true, []).count,
                   failed:       stats.fetch(false, []).count
  end
end

