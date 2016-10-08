require 'rspec'
require 'buyma_insider'

describe RestClient::Response do
  it 'should have content length' do
    response = Http.get 'http://google.ca'

    expect(response.headers.key?(:content_length)).to be_truthy
    expect(response).to respond_to :content_length

    content_length_header = response.content_length
    expect(content_length_header).to be > 0
  end

  it 'should use zlib to calculate size if no content-length header' do
    response = Http.get 'http://google.ca'
    expect(response).to respond_to :content_length
    content_length_header = response.content_length
    response.headers.delete :content_length
    deflat_zip_length = response.content_length
    expect(deflat_zip_length).to be > 0
    expect((content_length_header - deflat_zip_length).abs).to be_between(0, 20)
  end
end