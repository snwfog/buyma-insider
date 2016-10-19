class RedisCleanupWorker < Worker::Base
  recurrence { daily.hour_of_day(6) }

  def perform(opts = { time_limit: Time.now.utc })
    $redis.with do |conn|
      delete_expired_new_articles(opts, conn)
    end
  end

  private
  def delete_expired_new_articles(opts, conn)
    time_now             = opts[:time_limit]
    expired_articles_ids = conn.zscan_each(:'articles:new:expires_at')
                             .take_while { |article|
      _article_id, expires_at = *article
      expires_at_time         = Time.at(expires_at).utc
      expires_at_time <= time_now
    }.map(&:first)

    conn.pipelined do
      conn.zrem(:'articles:new:expires_at', expired_articles_ids)
      expired_articles_ids
        .group_by { |article_id| article_id.split(':').first }
        .each_pair do |merchant_code, articles|
          conn.hincrby :'articles:new:summary', merchant_code, -articles.count
        end
    end
  end
end