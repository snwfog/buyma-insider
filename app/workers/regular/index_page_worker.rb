# given index pages that exists for a merchant
# grab all existing indexes and check for if addition index pages
# can be inferred from cached pages
class IndexPageWorker < Worker::Base
  def perform(merchant_code)
    merchant = Merchant.find_by_code!(merchant_code)
    merchant.index_pages.root.each do |index_page|
      unless index_page.cache.exists?
        logger.warn "Index page #{index_page} is skipped, it does not have a cached document."
        next
      end

      logger.info "Parsing pager from index page [#{index_page}] for indices."
      index_page.extract_index_pages!.each do |child_index_page|
        if child_index_page.save
          logger.info "Merchant [#{merchant.name}] new index page [#{child_index_page}]."
        else
          logger.error "Merchant [#{merchant.name}] index page [#{child_index_page} is invalid."
          logger.error "Reason: #{child_index_page.errors.full_messages}."
        end
      end
    end
  end
end