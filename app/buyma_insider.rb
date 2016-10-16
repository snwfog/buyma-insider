require 'require_all'
require 'dotenv'

Dotenv.load

# TODO: Add autoload (a la Rails)
require_rel '../config/initializers/'
require_rel './buyma_insider/crawler'
require_rel './buyma_insider/http'
require_rel './buyma_insider/url_cache'

require_rel './buyma_insider/indexer/base'
require_rel './buyma_insider/indexer/ssense'
require_rel './buyma_insider/indexer/zara'

require_rel './buyma_insider/merchant/base'
require_rel './buyma_insider/merchant/ssense'
require_rel './buyma_insider/merchant/zara'

require_rel './buyma_insider/workers/worker'
require_rel './buyma_insider/workers/crawler_worker_base'
require_rel './buyma_insider/workers/example_worker'

require_rel './buyma_insider/workers/scheduled/ssense_worker'
require_rel './buyma_insider/workers/scheduled/zara_worker'
require_rel './buyma_insider/workers/scheduled/redis_cleanup_worker'

require_rel './buyma_insider/models/'
require_rel './buyma_insider/utils/'

module BuymaInsider
  NAME             = 'buyma_insider'
  ENVIRONMENT      = ENV['ENVIRONMENT']
  SPOOF_USER_AGENT = 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.57 Safari/537.36'
end
