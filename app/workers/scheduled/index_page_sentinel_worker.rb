# crawl all root index pages
# parse page and check if page is healthy or not
# be more aggressive in the validation of
# http index_page_status code and page html structure
class IndexPageSentinelWorker < Worker::Base
  def perform
    logger.info 'Sentinel Started'
    root_indices = IndexPage.includes(:merchant).root.all
    slack_notify(text: ":japanese_ogre: *Sentinel Started*\nChecking #{root_indices.count} root index pages")
    all_statuses = root_indices.map { |index_page| check_index_page_health(index_page) }
    
    logger.info JSON.pretty_generate(all_statuses)
    
    status_groups = all_statuses.sort_by! { |index_page_status| index_page_status[:http_status] }
                                .group_by { |index_page_status| http_status_category(index_page_status[:http_status]) }
    
    # TODO: Clunky, change this later
    slack_notify(sentinel_report(status_groups))
  end
  
  def sentinel_report(group_by_statuses)
    colors = { :'2xx' => '008000', :'3xx' => 'FFD700',
               :'4xx' => 'FF0000', :'5xx' => 'C71585' }
    
    Hash[:text, ':japanese_ogre: *Sentinel Report*'].tap do |report|
      report[:attachments] ||= []
      group_by_statuses.each do |status, index_pages|
        report[:attachments][status.to_sym] = {
          color: colors[status.to_sym],
          title: status,
          text:  index_pages.join('\n'),
          ts:    Time.now.to_i
        }
      end
    end
  end
  
  def check_index_page_health(index_page)
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
    
    { index_page:     index_page.full_url,
      http_status:    raw_response.try(:code),
      size_in_kb:     file_size_in_kb || 0.0,
      relocation:     raw_response.try(:history).try(:any?),
      articles_count: article_nodes.try(:count), }
  end
  
  def http_status_category(status)
    case status[:http_status]
    when 500..599
      :'5xx'
    when 400..499
      :'4xx'
    when 300...400
      :'3xx'
    when 200...300
      if status[:relocation] || status[:articles_count] < 10
        :'3xx'
      else
        :'2xx'
      end
    else
      :'5xx'
    end
  end
end