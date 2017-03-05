require 'rest_client'

##
# Extension for RestClient::Response
#
class RestClient::Response
  def content_length
    (headers[:content_length] ||
      Zlib::Deflate.deflate(body).size).to_i # Approximate
  end
end