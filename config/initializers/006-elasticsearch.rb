# Elasticsearch configuration

pool_cfg          = { size: 5, timeout: 5 }
elasticsearch_cfg = Hash.new.tap do |h|
  unless BuymaInsider.production?
    h[:logger] = Logging.logger[:Elasticsearch]
    h[:trace]  = true
  end
end

initializer    = lambda { Elasticsearch::Client.new(elasticsearch_cfg) }
$elasticsearch = if BuymaInsider.production?
                   ConnectionPool.new(pool_cfg, &initializer)
                 else
                   ConnectionPool::Wrapper.new(pool_cfg, &initializer)
                 end

