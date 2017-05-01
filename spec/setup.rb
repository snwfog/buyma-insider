# def MerchantMetadatum.load
#   config = YAML.load_file(File.expand_path('../../config/merchant.yml', __FILE__))
#   config.each_key.map { |k| MerchantMetadatum.new(config[k]) }
# end
#
# def get_test_article(attrs = {})
#   Article.new({
#                 id:          "abc:#{Faker::Code.ean}",
#                 merchant_id: 'abc',
#                 name:        Faker::Commerce.product_name,
#                 price:       Faker::Commerce.price,
#                 description: Faker::Commerce.product_name,
#                 link:        '//test1.com',
#               }.merge(attrs))
# end
require 'buyma_insider'

def get_article(opts = {})
  Article.new({ id:          "abc:#{Faker::Code.ean}",
                merchant_id: 'zar',
                sku:         Faker::Code.ean,
                name:        Faker::Commerce.product_name,
                price:       Faker::Commerce.price,
                description: Faker::Commerce.product_name,
                link:        '//test1.com', }.merge(opts))
end

def get_user
  User.new({ username: Faker::Internet.user_name,
             email:    Faker::Internet.email,
             password: 123 })
end

def get_exchange_rate
  ExchangeRate.new(base:      :CAD,
                   timestamp: Time.now,
                   rates:     { CAD: 1 })
end

def get_shipping_service
  ShippingService.new(service_name:   'shipping service: integration test',
                      rate:           1.0,
                      weight_in_kg:   1.2,
                      arrive_in_days: 1,
                      tracked:        false)
end

