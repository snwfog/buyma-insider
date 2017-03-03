require 'slackiq'
require 'logging'

if ENV['RACK_ENV'] =~ /prod(uction)?/i
  Slackiq.configure worker: ENV['SLACK_WEB_HOOK']
else
  if defined?(HTTParty)
    class << HTTParty
      alias_method :_post, :post
      
      def post(*args, &block)
        url = args.dup.shift
        if url =~ 'hooks.slack.com/services'
          logger = Logging.logger[:'Slack Notification']
          logger.info args.shift
        else
          _post(*args, &block)
        end
      end
    end
  end
end