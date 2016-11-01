require 'yaml'
require 'nobrainer'
require 'buyma_insider'

def MerchantMetadata.load
  config = YAML.load_file(File.expand_path('../../config/merchant.yml', __FILE__))
  config.each_key.map { |k| MerchantMetadata.new(config[k]) }
end

