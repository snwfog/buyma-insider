require 'buyma_insider'
require 'rspec'

describe SsenseWorker do
  it 'should crawl' do
    SsenseWorker.new.perform
  end
end