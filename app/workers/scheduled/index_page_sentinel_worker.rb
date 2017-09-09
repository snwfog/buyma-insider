# crawl all root index pages
# parse page and check if page is healthy or not
# be more aggressive in the validation of
# http index_page_status code and page html structure
class IndexPageSentinelWorker < Worker::Base
  def perform
    logger.info 'Sentinel Started'
    root_indices        = IndexPage.includes(:merchant).root.all
    statuses_grouped_by = root_indices.map { |index_page| get_index_page_status(index_page) }
                            .sort_by!(&:http_status)
                            .group_by(&:http_status)

    slack_notify(sentinel_slack_report(statuses_grouped_by))
  end

  private
  def get_index_page_status(index_page)
    merchant     = index_page.merchant
    raw_response = fetch_uri(index_page.full_url)

    FileUtils.cp(raw_response.file.path, index_page.cache.html_path)
    article_nodes = Nokogiri::HTML(index_page.cache.html_document)
                      .css(merchant.metadatum.item_css)
  rescue RestClient::ExceptionWithResponse => ex
    raw_response = ex.response
  rescue => ex
    Raven.capture_exception(ex)
  ensure
    return Hashie::Mash.new(index_page:     index_page.full_url,
                            http_status:    raw_response.try(:code),
                            size_in_kb:     index_page.cache.size_in_kb,
                            redirection:    raw_response.history.try(:any?),
                            articles_count: article_nodes.try(:count))
  end

  def sentinel_slack_report(statuses_grouped_by)
    colors = { :'2xx' => '008000', :'3xx' => 'FFD700',
               :'4xx' => 'FF0000', :'5xx' => 'C71585' }

    Hash[:text, ':japanese_ogre: *Sentinel Report*'].tap do |report|
      report[:attachments] = []
      statuses_grouped_by.each do |status, index_page_statuses|
        report[:attachments] << { color: colors[status],
                                  title: status,
                                  text:  "#{index_page_statuses.count} Index Pages",
                                  ts:    Time.now.to_i }
      end
    end
  end
end