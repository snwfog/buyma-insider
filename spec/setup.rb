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

def get_article
  Article.new({ id:          "abc:#{Faker::Code.ean}",
                merchant_id: 'zar',
                sku:         Faker::Code.ean,
                name:        Faker::Commerce.product_name,
                price:       Faker::Commerce.price,
                description: Faker::Commerce.product_name,
                link:        '//test1.com', })
end

def get_user
  User.new({ username:      :snwfog,
             password_hash: 'z'*60 })
end
