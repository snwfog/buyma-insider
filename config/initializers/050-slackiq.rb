Slackiq.configure worker: ENV['SLACK_WEB_HOOK']

unless BuymaInsider.production?
  class << Slackiq
    def notify(opts)
      @logger ||= Logging.logger.root
      @logger.info JSON.pretty_generate(opts)
    end
  end
end