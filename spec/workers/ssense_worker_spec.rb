require 'buyma_insider'
require 'rspec'

describe Worker::SsenseWorker do
  it 'should crawl' do
    Worker::SsenseWorker.new.perform
  end
end