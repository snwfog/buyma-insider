require 'buyma_insider'

def get_test_article(attrs = {})
  Article.new({
                id:          "abc:#{Faker::Code.ean}",
                merchant_id: 'abc',
                name:        Faker::Commerce.product_name,
                price:       Faker::Commerce.price,
                description: Faker::Commerce.product_name,
                link:        '//test1.com',
              }.merge(attrs))
end

