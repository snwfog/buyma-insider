require 'sidekiq'

module Worker
  class Base
    include ::Sidekiq::Worker

    protected

    # Fetch uri with capture to sentry
    # return RestClient::RawResponse
    def fetch_page_with_capture(uri, verify_ssl, retries = 3, **headers)
      retry_count = 0
      logger.info { "`GET` #{uri}" }
      logger.debug { JSON.pretty_generate(headers) }

      RestClient::Request.execute(url:          uri,
                                  method:       :get,
                                  verify_ssl:   verify_ssl,
                                  raw_response: true,
                                  headers:      headers)

    rescue OpenSSL::SSL::SSLError
      retry_count += 1
      logger.warn { 'Fetching `%s` failed with SSL error (%i times)' % [uri, retry_count] }
      retry if retry_count <= retries
      nil
    rescue Exception => ex
      Sentry.capture_exception(ex)
      logger.error { 'Fail fetch index page %s' % uri }
      raise
    end
  end
end
