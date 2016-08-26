require 'rest_client'

module Concerns::Crawler
  class Http
    def raw_response(address)
      RestClient::Request.execute(method: :get, url: address, raw_response: true)
    end

    def decode_response(raw_response)
      RestClient::Request.decode(raw_response.headers[:content_encoding], raw_response.file.open.read)
    end

    def response(decoded_response, raw_response)
      RestClient::Response.create(decoded_response, raw_response.net_http_res, raw_response.request)
    end
  end
end