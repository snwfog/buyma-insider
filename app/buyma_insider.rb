require 'require_all'
require 'dotenv'

Dotenv.load

require_rel '../config/initializers/'
require_rel './buyma_insider/crawler'
require_rel './buyma_insider/http'
require_rel './buyma_insider/url_cache'

require_rel './buyma_insider/merchant/'
require_rel './buyma_insider/workers/'
require_rel './buyma_insider/models/'
require_rel './buyma_insider/utils/'
require_rel './serializers'

module BuymaInsider
  NAME             = 'buyma_insider'
  ENVIRONMENT      = ENV['ENVIRONMENT']
  SPOOF_USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.28 Safari/537.36'
end
