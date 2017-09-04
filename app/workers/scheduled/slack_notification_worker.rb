class SlackNotificationWorker < Worker::Base
  def perform(ago_in_hour = 1)
    report_time       = ago_in_hour.hour.ago
    report_time_range = report_time.beginning_of_hour..report_time.end_of_hour
    # { merchant_code: { counts... } }
    report_agg = CrawlHistory
                   .includes(index_page: :merchant)
                   .where(created_at: report_time_range)
                   .inject(Hash.new { |k, v| k[v] = Hash.new(0) }) do |crawl_history_agg, crawl_hist|

      merchant = crawl_hist.index_page.merchant

      crawl_history_agg[merchant.name][:articles_count]         += crawl_hist.article_count
      crawl_history_agg[merchant.name][:articles_invalid_count] += crawl_hist.article_invalid_count
      crawl_history_agg[merchant.name][:index_pages_count]      += 1

      crawl_history_agg
    end

    report_attachment_fields = report_agg.map do |merchant_name, agg|
      { title: merchant_name.titleize,
        value: "*#{agg[:index_pages_count]}* Index Pages\n*#{agg[:articles_count]}* Articles\n*#{agg[:articles_invalid_count]}* Invalid Articles",
        short: true }
    end

    slack_notify(text:        ':spider: *Spider Report*',
                 attachments: [fields: report_attachment_fields,
                               ts:     Time.now.to_i,
                               footer: "Report time #{report_time.beginning_of_hour.strftime('%FT%R')} :clock#{report_time.hour - 12}:"])

  end
end