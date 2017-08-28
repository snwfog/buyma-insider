# crawl all root index pages
# parse page and check if page is healthy or not
# be more aggressive in the validation of
# http status code and page html structure
class IndexPageSentinelWorker < Worker::Base
  def perform
    logger.info 'Sentinel Started'
    root_indices = IndexPage
                     .includes(:merchant)
                     .root
                     .all
    slack_notify(text: "Sentinel: Checking all #{root_indices.count} root index pages")
    all_statuses = root_indices.map { |index_page| check_health(index_page) }

    logger.info JSON.pretty_generate(all_statuses)

    status_groups = all_statuses.group_by { |status| status[:health] }
    slack_notify(attachments: {
      text:   '4xx - 5xx',
      fields: status_groups[:red].map { |status| { title: status[:index_page],
                                                   value: "#{status[:http_status]}",
                                                   short: false } }
    })
  end

  def check_health(index_page)
    begin
      merchant     = index_page.merchant
      raw_response = fetch_uri(index_page.full_url)
      # FileUtils.cp(raw_resp_tempfile.file.path, index_page.cache_html_path)
      gzip_encoded_html = File.open(raw_response.file.path, 'rb') { |f| f.read }
      file_size_in_kb   = gzip_encoded_html.size / 1000.0
      html_document     = RestClient::Request.decode('gzip', gzip_encoded_html)
      article_nodes     = Nokogiri::HTML(html_document).css(merchant.metadatum.item_css)
    rescue RestClient::ExceptionWithResponse => ex
      raw_response = ex.response
    end

    status = { index_page:     index_page.full_url,
               http_status:    raw_response.try(:code),
               size_in_kb:     file_size_in_kb || 0,
               relocation:     raw_response.try(:history).try(:any?),
               articles_count: article_nodes.try(:count), }

    status[:health] = health_code(status)
    status
  end

  def health_code(status)
    case status[:http_status]
    when 400..599
      :red
    when 300...400
      :yellow
    when 200...300
      if status[:relocation] || status[:articles_count] < 10
        :yellow
      else
        :green
      end
    else
      :red
    end
  end
end