class IndexPageParseWorker < Worker::Base
  def perform(index_page_id)
    history        = CrawlHistory
                       .where(index_page_id: index_page_id)
                       .where(status: :completed)
                       .first
    merchant       = history.index_page.merchant
    cache_filename = history.index_page.cache_filename
    cache_dir      = "./tmp/cache/crawl/#{merchant.id}"
    cache_filepath = '%s/%s' % [cache_dir, cache_filename]
    index_summary  = '`%s`[%s]' % [history.index_page, cache_filepath]
    
    logger.info { 'Parsing article for index %s' % index_summary }
    if File.exist?(cache_filepath)
      logger.info { 'Found! Reading from cache file content...' }
      cache_file_content = File.open(cache_filepath, 'rb') { |file| file.read }
    else
      raise 'Cache file not found %s' % index_summary
    end
    
    body          = read_cache_file(cache_file_content, history.content_encoding)
    item_css      = merchant.metadatum.item_css
    document      = Nokogiri::HTML(body, nil, 'utf-8')
    article_nodes = document.css(item_css)
    logger.info { 'Start parsing files with `%i` articles' % article_nodes.count }
    article_nodes.each do |it|
      begin
        attrs      = merchant.attrs_from_node(it)
        article_id = attrs[:id]
        
        raise 'No valid id was found in parsed article attributes' unless article_id =~ /[a-z]{3}:[a-z0-9]+/
        
        if article = Article.find?(article_id)
          # Bust the (serializer) cache and touch the record
          article.update!(attrs.merge(updated_at: Time.now.utc.iso8601))
          # ArticleUpdatedWorker.perform_async(article.id)
          CrawlHistoryArticle.upsert!(crawl_history: history,
                                      article:       article,
                                      status:        :updated)
          ArticleUpdatedWorker.perform_async(article_id)
          history.updated_articles_count += 1
          logger.info { 'Updated %s ...' % article_id }
        else
          article = Article.create!(attrs.merge(merchant: merchant))
          CrawlHistoryArticle.create!(crawl_history: history,
                                      article:       article,
                                      status:        :created)
          ArticleCreatedWorker.perform_async(article_id)
          history.created_articles_count += 1
          logger.info { 'Created %s ...' % article_id }
        end
        
        article.update_price_history!
        history.items_count += 1
      rescue Exception => ex
        history.invalid_items_count += 1
        
        logger.warn { 'Failed creating article: %s' % ex.message }
        logger.warn { attrs }
        logger.debug { it.to_html }
      ensure
        history.save
      end
    end
    
    logger.info { 'Finished parsing %s' % index_summary }
    history
  end
  
  private
  
  def read_cache_file(body, encoding = nil)
    RestClient::Request.decode(encoding, body)
  end
end