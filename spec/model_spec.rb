require 'faker'
require 'minitest/autorun'

require 'buyma_insider'
require 'nobrainer_config'

class ArticleModelBaseTest < Minitest::Test
  def test_create_base_article
    a  = Article.create sku:         Faker::Code.ean,
                        name:        Faker::Commerce.product_name,
                        description: Faker::Hipster.sentences,
                        link:        Faker::Internet.url
    ph = PriceHistory.create article_id: a.id,
                             prices:     { time_now => Faker::Commerce.price,
                                           time_now => Faker::Commerce.price }
  end

  def time_now
    Time.now.utc.to_i.to_s
  end
end