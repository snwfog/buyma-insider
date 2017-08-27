BuymaInsider.configure do |config|
  config[:slack_notifier] = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL'] do
    # send slack notification to prompt instead of actual channel
    unless BuymaInsider.production?
      http_client(Class.new do
        def self.post uri, params = {}
          logger ||= Logging.logger.root
          logger.info uri
          logger.info JSON.pretty_generate(params)
        end
      end)
    end
  end
end
