require 'rspec'
require 'faker'
require 'active_support'
require 'active_support/core_ext/numeric/time'

require 'buyma_insider'
require 'nobrainer'

class SubArticle < Article;
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
      link: '//google.com'
    )

    expect(ch.persisted?).to be_truthy
  end

  it 'should not persist when not valid' do
    ch = CrawlHistory.create
    expect(ch.persisted?).to be_falsey
    expect { CrawlHistory.create! }.to raise_error(NoBrainer::Error::DocumentInvalid)
  end
end
