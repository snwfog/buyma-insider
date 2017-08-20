# given index pages that exists for a merchant
# grab all existing indexes and check for if addition index pages
# can be inferred from cached pages
class IndexPageWorker < Worker::Base
  def perform(merchant_code)
    merchant      = Merchant.find_by_code!(merchant_code)
    indexer_klass = merchant.indexer
    merchant.index_pages.root.each do |index_page|
      unless index_page.has_cache_html?
        logger.warn "Index page #{index_page} is skipped, it does not have a cached document"
        next
      end

      logger.info "Parsing pager from index page [#{index_page}] for indices"
      indexer_klass.new(index_page).compute!.each do |index_page|
        if index_page.save
          logger.info "Merchant [#{merchant.name}] new index page [#{index_page}]"
        else
          logger.error "Merchant [#{merchant.name}] index page [#{index_page} is invalid."
          logger.error "Reason: #{index_page.errors.full_messages}"
        end
      end
    end
  end
end