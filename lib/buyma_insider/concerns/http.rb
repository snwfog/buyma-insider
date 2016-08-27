require 'rest_client'

module Concerns
  module Http
    # Shortcut to get
    def get(address)
      @response = RestClient.get(address,
                                 headers: { user_agent: BuymaInsider::SPOOF_USER_AGENT })
    end

    def content_length
      @response.headers[:content_length] || Zlib::Deflate.deflate(@response.body).size # Approximate
    end

    def raw_response(address)
      RestClient::Request.execute(method:  :get, url: address, raw_response: true,
                                  headers: { user_agent: BuymaInsider::SPOOF_USER_AGENT })
    end

    def decode_response(raw_response)
      RestClient::Request.decode(raw_response.headers[:content_encoding], raw_response.file.open.read)
    end

    def response(decoded_response, raw_response)
      RestClient::Response.create(decoded_response, raw_response.net_http_res, raw_response.request)
    end
  end
end