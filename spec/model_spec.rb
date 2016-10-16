require 'rspec'
require 'minitest/autorun'
require 'faker'
require 'active_support'
require 'active_support/core_ext/numeric/time'

require 'buyma_insider'
require 'nobrainer'

class Article
  self.merchant_code = 'tes'
end

describe Article do
  it 'should be persisted' do
    a = Article.create id:          Faker::Code.ean,
                       name:        Faker::Commerce.product_name,
                       description: Faker::Hipster.sentence,
                       price:       Faker::Commerce.price,
                       link:        Faker::Internet.url
    expect(a.persisted?).to be true
  end

  it 'should support inheritance' do
    sub = SubArticle.create id:          Faker::Code.ean,
                            name:        Faker::Commerce.product_name,
                            description: Faker::Hipster.sentence,
                            price:       Faker::Commerce.price,
                            link:        Faker::Internet.url
    expect(sub.persisted?).to be true
  end

  it 'should create new article redis on creating an new article' do
    id = Faker::Code.ean
    expect(RedisConnection.sadd).to receive(['new_articles', id])
    Article.create id:          id,
                   name:        Faker::Commerce.product_name,
                   description: Faker::Hipster.sentence,
                   price:       Faker::Commerce.price,
                   link:        Faker::Internet.url
  end
end

class SubArticle < Article
  self.merchant_code = 'sub'
end

describe SubArticle do
  xit 'should trigger after_find on upsert!' do
    first_article = Article.upsert!(
      id:          Faker::Bitcoin.address,
      name:        Faker::Commerce.product_name,
      price:       Faker::Commerce.price,
      description: Faker::Commerce.product_name,
      link:        '//test1.com',
      '_type':     SubArticle.to_s
    )

    expect(first_article.persisted?).to be_truthy
    expect(first_article.new_article).to be_truthy

    same_article = Article.upsert!(
      id:          first_article.id,
      name:        'Second name',
      price:       '0.99',
      description: 'Second name',
      link:        '//test2.com',
      '_type':     SubArticle.to_s
    )

    expect(same_article.id).to be_equal(first_article.id)
    expect(same_article.new_article).to be_falsey
  end
end

describe PriceHistory do
  it 'should be persisted' do
    ph = PriceHistory.create(
      article_id: SecureRandom.base64(22),
      currency:   'CAN',
      history:    {
        1.day.from_now.utc.to_i.to_s => 123.23,
        2.day.from_now.utc.to_i.to_s => 123.23
      }
    )

    expect(ph.persisted?).to be true
  end

  it 'should be able to add price' do
    ph = PriceHistory.new(
      article_id: SecureRandom.base64(22),
      currency:   'CAN',
    )

    ph.add_price(123.00)
    ph.save

    expect(ph.persisted?).to be true
  end
end

describe CrawlHistory do
  it 'should persist' do
    ch = CrawlHistory.create(
      description: "New crawl #{Faker::Internet.url}",
      link:        '//google.com'
    )

    expect(ch.persisted?).to be_truthy
  end

  it 'should not persist when not valid' do
    ch = CrawlHistory.create
    expect(ch.persisted?).to be_falsey
    expect { CrawlHistory.create! }.to raise_error(NoBrainer::Error::DocumentInvalid)
  end
end
