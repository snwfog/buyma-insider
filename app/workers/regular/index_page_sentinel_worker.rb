# crawl all root index pages
# parse page and check if page is healthy or not
# be more aggressive in the validation of
# http status code and page html structure
class IndexPageSentinelWorker < Worker::Base
  def perform
    logger.info 'Sentinel Started'
    all_root_index_pages = IndexPage
                             .root
                             .includes(merchant: :merchant_metadatum)
                             .all
    slack_notify(text: "Sentinel: Checking all #{all_root_index_pages.count} root index pages")
    index_pages_status = all_root_index_pages.map { |index_page| check_health(index_page) }

    logger.info index_pages_status
    slack_notify(attachments: index_pages_status)
  end

  def check_health(index_page)
    merchant     = index_page.merchant
    raw_response = fetch_uri(index_page.full_url)
    # FileUtils.cp(raw_resp_tempfile.file.path, index_page.cache_html_path)
    gzip_encoded_html = File.open(raw_response.file.path, 'rb') { |f| f.read }
    file_size_in_kb   = gzip_encoded_html.size / 1000.0
    html_document     = RestClient::Request.decode('gzip', gzip_encoded_html)
    article_nodes     = Nokogiri::HTML(html_document).css(merchant.metadatum.item_css)

    # unless article_nodes.any?
    #   slack_notify(text: "Could not find any article nodes from index page #{index_page.full_url}")
    # end

    { http_status:    raw_response.code,
      size_in_kb:     file_size_in_kb,
      redirection:    raw_response.history.count,
      articles_count: article_nodes.count, }
  rescue RestClient::ExceptionWithResponse => ex
    slack_notify(text: "Index Page #{index_page.full_url} fetch failed.")
    slack_notify(text: ex.message)
  end
end