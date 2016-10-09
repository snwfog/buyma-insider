require 'slackiq'

Slackiq.configure worker: ENV['SLACK_WEB_HOOK']