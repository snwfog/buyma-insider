class IndexPageParseWorker < Worker::Base
  def perform(crawl_history_id)
    crawl_history = CrawlHistory.find(crawl_history_id)
    index_page    = crawl_history.index_page
    merchant      = index_page.merchant

    unless index_page.has_cache_html?
      raise "Cache file not found `#{index_page}' at [#{index_page.cache_html_path}]"
    end
    item_css      = merchant.metadatum.item_css
    article_nodes = Nokogiri::HTML(index_page.cache_html_document).css(item_css)
    logger.info 'Start parsing index page html %s with `%i` articles' % [index_page, article_nodes.count]
    article_nodes.each do |it|
      begin
        article_attrs = merchant.attrs_from_node(it)

        logger.debug 'Article properties'
        logger.debug JSON.pretty_generate(article_attrs)

        if article = Article.find_by_sku(article_attrs[:sku])
          # Bust the (serializer) cache and touch the record
          # article_attrs might have not be changed, in this case
          # updated_at is not updated
          article.touch unless article.update!(article_attrs)

          unless crawl_history.articles.exists?(id: article.id)
            crawl_history.articles << article
          end

          ArticleUpdatedWorker.perform_async(article.id)
          crawl_history.increment!(:article_updated_count)
          logger.info { 'Updated %s ...' % article.name }
        else
          article = merchant.articles.create!(article_attrs)
          crawl_history.articles << article

          ArticleCreatedWorker.perform_async(article.id)
          crawl_history.increment!(:article_created_count)
          logger.info { 'Created %s ...' % article.name }
        end

        crawl_history.increment!(:article_count)
      rescue Exception => ex
        crawl_history.increment!(:article_invalid_count)

        logger.error 'Failed creating article: %s' % ex.message
        logger.error ex.backtrace
        logger.error article_attrs
        logger.error it.to_html
      ensure
        crawl_history.save
      end
    end

    logger.info "Finished parsing #{index_page}"
    crawl_history
  end
end
