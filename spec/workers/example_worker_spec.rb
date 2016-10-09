require 'buyma_insider'
require 'rspec'

describe Worker::ExampleWorker do
  it 'should crawl' do
    Worker::ExampleWorker.new.perform
  end
end