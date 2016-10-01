require 'faker'
require 'minitest/autorun'
require 'active_support'
require 'active_support/core_ext/numeric/time'

require 'buyma_insider'
require 'nobrainer'

class ArticleModelBaseTest < Minitest::Test
  def test_create_article_should_be_persisted
    a = Article.create id:          Faker::Code.ean,
                       name:        Faker::Commerce.product_name,
                       description: Faker::Hipster.sentence,
                       price:       Faker::Commerce.price,
                       link:        Faker::Internet.url
    assert a.persisted?, 'Article should be persisted'
  end

  def test_article_base_support_inheritance
    sub = SubArticle.create id:          Faker::Code.ean,
                            name:        Faker::Commerce.product_name,
                            description: Faker::Hipster.sentence,
                            price:       Faker::Commerce.price,
                            link:        Faker::Internet.url
    assert sub.persisted?
  end

  def test_article_price_history_create
    ph = PriceHistory.create(
      article_id: SecureRandom.base64(22),
      currency:   'CAN',
      history:    {
        1.day.from_now.utc.to_i.to_s => 123.23,
        2.day.from_now.utc.to_i.to_s => 123.23
      }
    )

    assert ph.persisted?
  end

  def test_price_history_add_price
    ph = PriceHistory.new(
      article_id: SecureRandom.base64(22),
      currency:   'CAN',
    )

    ph.add_price(123.00)
    ph.save

    assert ph.persisted?
  end
end

class SubArticle < Article; end