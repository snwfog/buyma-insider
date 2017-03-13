# Elasticsearch configuration

pool_cfg       = { size: 5, timeout: 5 }
$elasticsearch = if ENV['RACK_ENV'] =~ /prod(uction)?/
                   ConnectionPool.new(pool_cfg) do
                     options          = {}
                     options[:logger] = Logging.logger[:Elasticsearch]
                     Elasticsearch::Client.new(options)
                   end
                 else
                   ConnectionPool::Wrapper.new(pool_cfg) { Elasticsearch::Client.new }
                 end

