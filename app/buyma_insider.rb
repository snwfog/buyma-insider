$:.unshift(File.expand_path('../lib', __FILE__))

require 'require_all'
require 'dotenv/load'

require_rel '../config/initializers/'

require_rel './models'
require_rel './serializers'

require_rel './buyma_insider/crawler'
require_rel './buyma_insider/http'
require_rel './buyma_insider/url_cache'

require_rel './buyma_insider/merchant/'
require_rel './buyma_insider/workers/'
require_rel './buyma_insider/utils/'

module BuymaInsider
  NAME             = 'buyma_insider'
  SPOOF_USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.28 Safari/537.36'
end
