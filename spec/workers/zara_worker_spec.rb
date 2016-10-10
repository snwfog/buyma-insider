require 'buyma_insider'
require 'rspec'

describe ZaraWorker do
  it 'should crawl' do
    ZaraWorker.new.perform
  end
end