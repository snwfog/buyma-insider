$:.unshift(File.expand_path('../../lib', __FILE__))

require 'require_all'
require 'dotenv/load'
require 'faker'

require_rel '../config/initializers/'

require_rel './helpers'
require_rel './models'
require_rel './serializers'
require_rel './controllers'
require_rel './workers'

require_all 'lib'

module BuymaInsider
  NAME             = 'buyma_insider'
  SPOOF_USER_AGENT = 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.54 Safari/537.36'
end
