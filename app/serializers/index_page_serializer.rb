class IndexPageSerializer < ActiveModel::Serializer
  HEALTH_GREEN  = :green
  HEALTH_ORANGE = :orange
  HEALTH_RED    = :red
  
  cache key: :index_page, expires_in: 5.minute
  
  attributes :id,
             :full_url,
             :relative_path,
             :last_synced_at,
             :health
  
  def last_synced_at
    if crawl_history = object.crawl_histories.first
      crawl_history.created_at
    end
  end
  
  def health
    crawl_histories                                    = object.crawl_histories.limit(10)
    valid_items_count_total, invalid_items_count_total = crawl_histories.inject([0, 0]) do |(v_it_cnt, inv_it_cnt), crawl_hist|
      v_it_cnt   += crawl_hist.items_count
      inv_it_cnt += crawl_hist.invalid_items_count
      [v_it_cnt, inv_it_cnt]
    end

    if not crawl_histories.any?(&:completed?) || invalid_items_count_total > valid_items_count_total
      HEALTH_RED
    elsif crawl_histories.any?(&:aborted?) || invalid_items_count_total > 0
      HEALTH_ORANGE
    else
      HEALTH_GREEN
    end
  end
end
