require 'logging'

Logging.logger.root.appenders = Logging.appenders.stdout
Logging.logger.root.level = :all

