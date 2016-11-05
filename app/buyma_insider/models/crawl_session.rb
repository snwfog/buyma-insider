require 'nobrainer'

class CrawlSession
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  has_many :crawl_histories

  field :id, primary_key: true, required: true

  def started_at
    crawl_histories.min_by(&:created_at)
  end

  def finished_at
    crawl_histories.max_by(&:finished_at)
  end

  def respond_to_missing?(m, *args)
    case m
    when :items_count,
      :invalid_items_count,
      :traffic_size,
      :elapsed_time
      true
    else
      super
    end
  end

  def method_missing(m, *args)
    case m
    when :items_count,
      :invalid_items_count,
      :traffic_size,
      :elapsed_time
      crawl_histories.map(&m).inject(:+)
    else
      super
    end
  end
end