require 'dotenv'

# load default .env, and environment specific .env
Dotenv.load([File.expand_path('../../.env', __FILE__),
             File.expand_path("../../.env.#{ENV['RACK_ENV']}", __FILE__)])
Bundler.require(:default, ENV['RACK_ENV']) # INFO: it increases boot time

module BuymaInsider
  NAME             = 'buyma_insider'.freeze
  VERSION          = '0.1.0'.freeze
  API_VERSION      = 'api/v1'.freeze
  SPOOF_USER_AGENT = 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.54 Safari/537.36'

  class << self
    def configuration
      @configuration ||= begin
        Hashie::Mash.new.tap do |cfg|
          cfg.secret_token_base = ENV['SECRET_TOKEN_BASE']
          cfg.redis             = Hashie::Mash.new(YAML.load_file(File.expand_path('../../config/redis.yml', __FILE__))[environment])
          cfg.database          = Hashie::Mash.new(YAML.load_file(File.expand_path('../../config/database.yml', __FILE__))[environment])
          cfg.postgres          = Hashie::Mash.new(YAML.load_file(File.expand_path('../../config/postgres.yml', __FILE__))[environment])
          cfg.logging           = Hashie::Mash.new(YAML.load_file(File.expand_path('../../config/logging.yml', __FILE__))[environment])
          cfg.elasticsearch     = Hashie::Mash.new(YAML.load_file(File.expand_path('../../config/elasticsearch.yml', __FILE__))[environment])
        end
      end
    end

    def configure
      yield configuration
    end

    # Return a redis pool for an app area that
    # requires redis connection, settings from redis.yml
    def redis_for(process)
      redis_cfg = configuration.redis[process.to_sym]
      pool_size = redis_cfg.dup.delete(:pool_size)
      ConnectionPool.new(size: pool_size) do
        Redis::Store::Factory.create(redis_cfg.to_h.symbolize_keys!)
      end
    end

    def logger_for(process)
      unless Logging::Repository.instance.has_logger?(process)
        raise 'Logger `%s` does not exists' % process
      end
      Logging.logger[process]
    end

    def environment
      ENV['RACK_ENV'] || :development
    end

    def root
      ENV['APP_PATH'] || File.expand_path('../../', __FILE__)
    end

    def base_url
      ENV['APP_BASE_URL']
    end

    # dev or development
    def development?
      environment =~ /dev/
    end

    # stag or stage or staging
    def staging?
      environment =~ /stag/
    end

    # prod or production
    def production?
      environment =~ /prod/
    end

    # test or unittest or integrationtest
    def test?
      environment =~ /test/
    end

    def handle_exception(ex, context = {})
      logger.error ex
    end
  end
end

require_rel '../lib'
require_rel '../config/initializers'

require_rel './models'
require_rel './helpers'
require_rel './controllers/application_controller',
            './workers/worker'

require_rel './controllers'
require_rel './serializers'
require_rel './channels'
require_rel './workers'

# require 'active_support/dependencies'
# ActiveSupport::Dependencies.autoload_paths += %w[app/controllers app/models app/serializers app/channels]
