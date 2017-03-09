require 'logging'

layout   = Logging.layouts.pattern(pattern: '[%d] %-5l -- %c : %m\n')
log_path = File.expand_path("../../../log/buyma-insider-#{ENV['RACK_ENV']}.log", __FILE__)

Logging.logger.root.level = :debug

Logging.logger.root.add_appenders(
  Logging.appenders.stdout(layout: layout))

Logging.logger.root.add_appenders(
  Logging.appenders.rolling_file(log_path,
                                 age:    'daily',
                                 layout: layout))


# worker          = Logging.logger[Merchant]
# worker.level    = :info
# worker.additive = false
#
# worker.add_appenders(Logging.appenders
#                        .stdout(:layout => Logging.layouts.pattern(
#                          :pattern => '[%d] %-5l -- %c : %m\n')))
#
# worker.add_appenders(Logging.appenders
#                        .rolling_file("./log/workers-#{ENV['ENVIRONMENT']}.log",
#                                      :age    => 'weekly',
#                                      :layout => Logging.layouts.pattern(
#                                        :pattern => '[%d] %-5l -- %c : %m\n')))

