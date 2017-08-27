# crawl index page, parse it, check if
# page is healthy or not
# be more aggressive in the validation of
# http status code and page html structure
class IndexPageSentinelWorker < Worker::Base
  def perform(index_page_id)
    index_page   = IndexPage
                     .includes(merchant: :merchant_metadatum)
                     .find(index_page_id)
    merchant     = index_page.merchant
    raw_response = fetch_url(index_page.full_url)

    # FileUtils.cp(raw_resp_tempfile.file.path, index_page.cache_html_path)
    gzip_encoded_html = File.open(raw_response.file.path, 'rb') { |f| f.read }
    html_document     = RestClient::Request.decode('gzip', gzip_encoded_html)
    article_nodes     = Nokogiri::HTML(html_document).css(merchant.metadatum.item_css)
    unless article_nodes.any?
      slack_notify(text: "Could not find any article nodes from index page #{index_page.full_url}")
    end
  rescue RestClient::ExceptionWithResponse => ex
    slack_notify(text: "Index Page #{index_page.full_url} fetch failed.")
    slack_notify(test: ex.message)
  end
end