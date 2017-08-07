class IndexPageParseWorker < Worker::Base
  def perform(index_page_id)
    index_page = IndexPage.eager_load(:merchant).find(index_page_id)
    logger.info "Index page parser started for index `#{index_page}'"
    last_history = CrawlHistory.where(index_page_id: index_page_id,
                                      status:        :completed).first
    merchant     = index_page.merchant
    raise "Cache file not found `#{index_page}'" unless index_page.cache_html_document
    item_css      = merchant.metadatum.item_css
    article_nodes = Nokogiri::HTML(index_page.cache_html_document).css(item_css)
    logger.info 'Start parsing files with `%i` articles' % article_nodes.count
    article_nodes.each do |it|
      begin
        attrs      = merchant.attrs_from_node(it)
        article_id = attrs[:id]

        logger.debug 'Article properties'
        logger.debug JSON.pretty_generate(attrs)

        unless article_id =~ /[a-z]{3}:[a-z0-9]+/
          raise 'No valid id was found in parsed article attributes'
        end

        if article = Article.find?(article_id)
          # Bust the (serializer) cache and touch the record
          article.update!(attrs.merge(updated_at: Time.now.utc.iso8601))
          # ArticleUpdatedWorker.perform_async(article.id)
          CrawlHistoryArticle.upsert!(crawl_history: last_history,
                                      article:       article,
                                      status:        :updated)
          ArticleUpdatedWorker.perform_async(article_id)
          last_history.updated_articles_count += 1
          logger.info { 'Updated %s ...' % article_id }
        else
          article = Article.create!(attrs.merge(merchant: merchant))
          CrawlHistoryArticle.create!(crawl_history: last_history,
                                      article:       article,
                                      status:        :created)
          ArticleCreatedWorker.perform_async(article_id)
          last_history.created_articles_count += 1
          logger.info { 'Created %s ...' % article_id }
        end

        article.update_price_history!
        last_history.items_count += 1
      rescue Exception => ex
        last_history.invalid_items_count += 1

        logger.warn 'Failed creating article: %s' % ex.message
        logger.warn attrs
        logger.debug it.to_html
      ensure
        last_history.save
      end
    end

    logger.info "Finished parsing #{index_page}"
    last_history
  end

  private

  def read_cache_file(body, encoding = nil)
    RestClient::Request.decode(encoding, body)
  end
end
