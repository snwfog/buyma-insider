# given index pages that exists for a merchant
# grab all existing indexes and check for if addition index pages
# can be inferred from cached pages
class IndexPageWorker < Worker::Base
  def perform(merchant_code)
    merchant      = Merchant.find_by_code!(merchant_code)
    indexer_klass = merchant.indexer
    merchant.index_pages.each do |index_page|
      logger.info "Parsing pager from index page [#{index_page}] for indices"
      indexer_klass.new(index_page).compute!.each do |index_page|
        if index_page.valid?
          logger.info "Merchant [#{merchant.name}] has an new index page [#{index_page}]"
          index_page.save
        else
          logger.error "Merchant [#{merchant.name}] found an invalid index page. Reason: #{index_page.errors.full_messages}"
        end
      end
    end
  end
end