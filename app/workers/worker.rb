module Worker
  class Base
    include ::Sidekiq::Worker

    protected

    def slack_notify(params = {})
      BuymaInsider
        .configuration
        .slack_notifier
        .post(params.merge!(channel: '#jobs'))
    end

    def validate_args(args, validator, message)
      unless validator.call(args)
        logger.error "#{self} aborted, arguments #{message}" and raise
      end
    end

    # Fetch uri with capture to Sentry.io
    # return RestClient::RawResponse
    def fetch_uri(uri, verify_ssl = false, retries = 3, **headers)
      retry_count = 0
      logger.info "`GET` #{uri}"
      logger.debug JSON.pretty_generate(headers)

      RestClient::Request.execute(url:          uri,
                                  method:       :get,
                                  verify_ssl:   verify_ssl,
                                  raw_response: true,
                                  headers:      headers)
    rescue OpenSSL::SSL::SSLError
      retry_count += 1
      logger.warn 'Fetching `%s` failed with SSL error (%i times)' % [uri, retry_count]
      retry if retry_count <= retries
      nil
    rescue Exception => ex
      Raven.capture_exception(ex)
      logger.error 'Fail fetch uri `%s`' % uri
      logger.error ex.message
      raise
    end
  end
end
