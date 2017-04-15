require 'buyma_insider'

include RethinkDB::Shortcuts

client = Elasticsearch::Client.new
conn   = r.connect(db: :"buyma_insider_#{BuymaInsider.environment}")
conn.repl

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
  User.new({ username: Faker::Internet.user_name,
             email:    Faker::Internet.email,
             password: 123 })
end

