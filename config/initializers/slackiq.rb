require 'slackiq'
require 'logging'

if ENV['ENVIRONMENT'] =~ /(PROD)|(production)/i
  Slackiq.configure worker: ENV['SLACK_WEB_HOOK']
else
  def Slackiq.notify(opts={})
    logger = Logging.logger[:Worker]
    logger.info(opts)
  end
end