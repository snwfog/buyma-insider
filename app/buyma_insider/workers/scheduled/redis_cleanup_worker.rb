class RedisCleanupWorker < Worker::Base
  recurrence { daily.hour_of_day(6) }

  def perform
    @opts = { expires_at: Time.now.utc }

    $redis.with do |conn|
      delete_expired_new_articles(conn, @opts)
    end
  end

  private
  def delete_expired_new_articles(conn, opts)
    expires_at           = opts[:expires_at]
    expired_articles_ids = conn.zscan_each(:'articles:new:expires_at')
                             .take_while { |article|
      _article_id, expires_at = *article
      expires_at_time         = Time.at(expires_at).utc
      expires_at_time <= expires_at
    }.map(&:first)

    unless expired_articles_ids.empty?
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
end