# Elasticsearch configuration
$elasticsearch = ConnectionPool.new(size: 5, timeout: 5) do
  options = {}
  options[:logger] = Logging.logger[:Elasticsearch]
  Elasticsearch::Client.new(options)
end
