require 'buyma_insider'
require 'minitest/autorun'

require_relative './setup'

class ArticleTest < Minitest::Test
  def test_should_considered_new
    article = get_test_article
    article.stub :created_at, Time.now.utc do
      assert article.valid?
      assert article.new?
    end
  end
end