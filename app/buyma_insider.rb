require 'bundler/setup'
Bundler.require(:default)

module BuymaInsider
  NAME             = 'buyma_insider'
  SPOOF_USER_AGENT = 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.54 Safari/537.36'
end

require_rel '../lib'
require_rel '../config/initializers/'

require_rel './helpers'
require_rel './models'
require_rel './serializers'
require_rel './controllers'
require_rel './workers'

