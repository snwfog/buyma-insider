class IndexPageParseWorker < Worker::Base
  def perform(crawl_history_id)
    @crawl_history = CrawlHistory.find(crawl_history_id)
    @index_page    = @crawl_history.index_page
    @merchant      = @index_page.merchant

    unless @index_page.cache.exists?
      raise "Web cache file not found for `#{@index_page}' at [#{@index_page.cache.path}]"
    end

    article_nodes = @index_page.extract_nodes!
    logger.info 'Start parsing index page html %s with `%i` articles' % [@index_page, article_nodes.count]
    article_nodes.each { |article_node| parse_article_node(article_node) }
  rescue => ex
    Raven.capture_exception(ex)
    logger.error "Error parse index page #{@index_page.full_url}"
    logger.error ex.message
  ensure
    logger.info "Finished parsing #{@index_page}"
    @crawl_history
  end

  private
  def parse_article_node(article_node)
    article_attrs = @merchant.extract_attrs!(article_node)

    logger.debug 'Article properties'
    logger.debug JSON.pretty_generate(article_attrs)

    if article = Article.find_by_sku(article_attrs[:sku])
      # Bust the (serializer) cache and touch the record
      # article_attrs might have not be changed, in this case
      # updated_at is not updated
      article.touch unless article.update!(article_attrs)

      unless @crawl_history.articles.exists?(id: article.id)
        @crawl_history.articles << article
      end

      ArticleUpdatedWorker.perform_async(article.id)
      @crawl_history.increment!(:article_updated_count)
      logger.info { 'Updated %s ...' % article.name }
    else
      article = @merchant.articles.create!(article_attrs)
      @crawl_history.articles << article

      ArticleCreatedWorker.perform_async(article.id)
      @crawl_history.increment!(:article_created_count)
      logger.info { 'Created %s ...' % article.name }
    end

    @crawl_history.increment!(:article_count)
  rescue => ex
    @crawl_history.increment!(:article_invalid_count)

    logger.error 'Failed creating article: %s' % ex.message
    logger.error ex.backtrace
    logger.error article_attrs
    logger.error article_node.to_html
  ensure
    @crawl_history.save
  end
end
