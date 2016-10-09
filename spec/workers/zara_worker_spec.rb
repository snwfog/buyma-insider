require 'buyma_insider'
require 'rspec'

describe Worker::ZaraWorker do
  it 'should crawl' do
    Worker::ZaraWorker.new.perform
  end
end