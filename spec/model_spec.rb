require 'rspec'
require 'minitest/autorun'
require 'faker'
require 'active_support'
require 'active_support/core_ext/numeric/time'

require 'buyma_insider'
require_relative './setup'

describe Article do
  it 'should be persisted' do
    a = get_test_article
    expect(a.save!).to be true
    expect(a.valid?).to be true
    expect(a.persisted?).to be true
  end

  it 'should be persisted once' do
    a = get_test_article
    expect(a.save!).to be true
    expect(a.valid?).to be true
    expect(a.persisted?).to be true

    Article.upsert! id:          a.id,
                    name:        a.name,
                    description: a.description,
                    price:       a.price,
                    link:        a.link
  end

  it 'should support inheritance' do
    sub = SubArticle.create! id:          "abc:#{Faker::Code.ean}",
                             merchant_id: 'abc',
                             name:        Faker::Commerce.product_name,
                             description: Faker::Hipster.sentence,
                             price:       Faker::Commerce.price,
                             link:        Faker::Internet.url

    expect(sub.valid?).to be true
    expect(sub.persisted?).to be true
  end

  xit 'should create new article redis on creating an new article' do
    id = "abc:#{Faker::Code.ean}"
    expect(RedisConnection.sadd).to receive(['new_articles', id])
    a = get_test_article
    a.save!
  end
end

SubArticle = Class.new(Article)
describe SubArticle do
  xit 'should trigger after_find on upsert!' do
    first_article = Article.upsert!(
      id:          "abc:#{Faker::Code.ean}",
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
    ph = PriceHistory.create!(
      article_id: "abc:#{Faker::Code.ean}",
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
      article_id: "abc:#{Faker::Code.ean}",
      currency:   'CAN',
    )

    ph.add_price(123.00)
    ph.save!

    expect(ph.persisted?).to be true
  end
end

describe CrawlHistory do
  it 'should persist' do
    crawl_session = CrawlSession.create!(merchant_id: 'abc')
    ch            = CrawlHistory.create!(
      merchant_id:   'abc',
      crawl_session: crawl_session,
      description:   "New crawl #{Faker::Internet.url}",
      link:          '//google.com'
    )

    expect(ch.persisted?).to be_truthy
    expect(ch.crawl_session.id).to eq(crawl_session.id)
  end

  it 'should not persist when not valid' do
    expect { CrawlHistory.create! }.to raise_error(NoBrainer::Error::DocumentInvalid)
  end
end
