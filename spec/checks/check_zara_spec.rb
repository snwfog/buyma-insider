require 'rspec'
require 'buyma_insider'

describe Zara do
  xit 'should reach merchant' do
    Zara.index_pages.map(&:index_url).each do |index|
      response = Http.get index
      expect(response.code).to be 200
    end
  end
end


