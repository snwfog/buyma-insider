require 'faker'
require 'minitest/autorun'
require 'active_support'
require 'active_support/core_ext/numeric/time'

require 'buyma_insider'
require 'nobrainer'

class ArticleModelBaseTest < Minitest::Test
  def test_create_base_article
    Article.create id:          Faker::Code.ean,
                   name:        Faker::Commerce.product_name,
                   description: Faker::Hipster.sentences,
                   link:        Faker::Internet.url
  end

  def test_article_base_support_inheritance
    SubArticle.create
  end

  def test_article_price_history_create
    ph = PriceHistory.new(
      article_id: SecureRandom.base64(22),
      currency:   'CAN',
      history:    {
        1.day.from_now.utc.to_i.to_s => 123.23,
        2.day.from_now.utc.to_i.to_s => 123.23
      }
    )
    ph.save
  end

  def test_price_history_add_price
    ph = PriceHistory.new(
      article_id: SecureRandom.base64(22),
      currency:   'CAN',
    )

    ph.add_price(123.00)
    ph.save
  end
end

class SubArticle < Article;
end