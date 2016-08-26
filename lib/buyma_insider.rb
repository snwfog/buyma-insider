require 'require_all'

require 'buyma_insider/concerns/crawler/http'

require 'buyma_insider/merchant/base'
require 'buyma_insider/merchant/ssense'

require 'buyma_insider/models/item'

require 'buyma_insider/persistence/conn'

module BuymaInsider
  SPOOF_USER_AGENT = 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.57 Safari/537.36'
end