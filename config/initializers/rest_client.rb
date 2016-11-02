require 'logging'
require 'rest-client'

unless ENV['ENVIRONMENT'] =~ /prod(uction)?/i
  RestClient.log = Logging.logger[:Http]
end
