Slackiq.configure worker: ENV['SLACK_WEB_HOOK']

unless BuymaInsider.production?
  class << Slackiq
    def notify(opts)
      @logger ||= Logging.logger[:'Slack Notification']
      @logger.info opts
    end
  end
end