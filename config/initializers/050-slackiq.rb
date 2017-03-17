Slackiq.configure worker: ENV['SLACK_WEB_HOOK']

unless ENV['RACK_ENV'] =~ /prod(uction)?/i
  class << Slackiq
    def notify(opts)
      @logger ||= Logging.logger[:'Slack Notification']
      @logger.info opts
    end
  end
end