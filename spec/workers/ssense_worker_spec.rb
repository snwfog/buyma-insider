require 'startup'
require 'rspec'

describe ExampleWorker do
  it 'should crawl' do
    ExampleWorker.new.perform
  end
end