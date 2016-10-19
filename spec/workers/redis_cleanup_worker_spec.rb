require 'faker'
require 'buyma_insider'
require 'minitest/autorun'
require 'rspec'

class RedisCleanupWorkerArticle < Article
  self.merchant_code = 'red'
end

class ARedisCleanupWorkerArticle < Article
  self.merchant_code = 'are'
end

describe RedisCleanupWorker do
  let(:articles_3) {
    Article.stub :new_articles_expires_at, -1.second do
      3.times.map {
        id = "#{RedisCleanupWorkerArticle.merchant_code}:#{Faker::Code.ean}"
        RedisCleanupWorkerArticle.create id:          id,
                                         name:        Faker::Commerce.product_name,
                                         description: Faker::Hipster.sentence,
                                         price:       Faker::Commerce.price,
                                         link:        Faker::Internet.url
      }
    end
  }

  let (:a_articles_3) {
    Article.stub :new_articles_expires_at, -1.second do
      3.times.map {
        id = "#{ARedisCleanupWorkerArticle.merchant_code}:#{Faker::Code.ean}"
        ARedisCleanupWorkerArticle.create id:          id,
                                          name:        Faker::Commerce.product_name,
                                          description: Faker::Hipster.sentence,
                                          price:       Faker::Commerce.price,
                                          link:        Faker::Internet.url
      }
    end
  }

  before do
    $redis.with do |conn|
      @new_article_count = conn.zcard(:'articles:new:expires_at')
      @red_article_count = conn.hget(:'articles:new:summary', :red).to_i
      @are_article_count = conn.hget(:'articles:new:summary', :are).to_i
    end
  end

  it 'should cleanup older items' do
    articles_3
    $redis.with do |conn|
      expect(conn.zcard(:'articles:new:expires_at')).to eq(@new_article_count + 3)
      expect(conn.hget(:'articles:new:summary', :red).to_i).to eq(@red_article_count + 3)
      RedisCleanupWorker.new.perform
      expect(conn.zcard(:'articles:new:expires_at')).to eq(@new_article_count)
      expect(conn.hget(:'articles:new:summary', :red).to_i).to eq(@red_article_count)
    end
  end

  it 'should cleanup older items and have proper summary values' do
    articles_3
    a_articles_3

    $redis.with do |conn|
      expect(conn.zcard(:'articles:new:expires_at')).to eq(@new_article_count + 6)
      expect(conn.hget(:'articles:new:summary', :red).to_i).to eq(@red_article_count + 3)
      expect(conn.hget(:'articles:new:summary', :are).to_i).to eq(@are_article_count + 3)

      RedisCleanupWorker.new.perform

      expect(conn.zcard(:'articles:new:expires_at')).to eq(@new_article_count)
      expect(conn.hget(:'articles:new:summary', :red).to_i).to eq(@red_article_count)
      expect(conn.hget(:'articles:new:summary', :are).to_i).to eq(@are_article_count)
    end
  end
end