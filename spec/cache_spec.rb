require 'rspec'
require 'minitest/autorun'
require 'faker'
require 'active_support'
require 'active_support/core_ext/numeric/time'

require 'buyma_insider'
require_relative './setup'

describe 'Cache' do
  it 'should cache serialized value' do
    article = get_test_article
    a_s     = ArticleSerializer.new(article)
    a_s.to_json
  end
end