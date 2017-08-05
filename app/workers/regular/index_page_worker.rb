# given index pages that exists for a merchant
# grab all existing indexes and check for if addition index pages
# can be inferred from cached pages
class IndexPageWorker < Worker::Base
  def perform(merchant_id)
    merchant      = Merchant.find!(merchant_id)
    indexer_klass = merchant.indexer
    merchant.index_pages.each do |index_page|
      logger.info "Parsing pager from index page [#{index_page}] for indices"
      indexer_klass.new(index_page).compute!.each do |index_page|
        if index_page.valid?
          logger.info "Merchant [#{merchant.name}] has an new index page [#{index_page}]"
          index_page.save
        end
      end
    end
  end
end