require 'rspec'
require 'buyma_insider'

describe Ssense do
  xit 'should reach merchant' do
    Ssense.index_pages.map(&:index_url).each do |index|
      response = Http.get "http:#{index}"
      expect(response.code).to be 200
    end
  end
end
