require 'dotenv/load'

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV']) # disable for now, as it increases boot time

module BuymaInsider
  NAME             = 'buyma_insider'
  SPOOF_USER_AGENT = 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.54 Safari/537.36'
  
  class << self
    def configuration
      @configuration ||= begin
        Hashie::Mash.new.tap do |cfg|
          cfg.secret_token_base = ENV['SECRET_TOKEN_BASE']
          cfg.redis             = Hashie::Mash.new(YAML.load_file('./config/redis.yml')[environment])
          cfg.database          = Hashie::Mash.new(YAML.load_file('./config/database.yml')[environment])
          cfg.logging           = Hashie::Mash.new(YAML.load_file('./config/logging.yml')[environment])
        end
      end
    end
    
    def environment
      ENV['RACK_ENV'] || :development
    end
    
    # copy&pasted from sinatra
    def development?; environment == /dev/  end # dev or development
    def production?;  environment =~ /prod/ end # prod or production
    def test?;        environment =~ /test/ end # test or unittest or integrationtest
  end
end

require_rel '../lib'
require_rel '../config/initializers/'

require_rel './helpers'
require_rel './models'
require_rel './controllers'
require_rel './serializers'
require_rel './controllers'
require_rel './workers'

