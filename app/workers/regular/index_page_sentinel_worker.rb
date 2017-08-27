# crawl index page, parse it, check if
# page is healthy or not
# be more aggressive in the validation of
# http status code and page html structure
class IndexPageSentinelWorker < Worker::Base
  def perform(index_page_id)

  end
end