require 'rspec'
require 'buyma_insider'
# Check article and layout

describe Zara do
  it 'should reach merchant' do
    Zara.index_pages.map(&:index_url).each do |index|
      response = Http.get index
      expect(response.status).to be 200
    end
  end
end


