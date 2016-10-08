require 'logging'

Logging.logger.root.level     = :info
Logging.logger.root.appenders = Logging.appenders
                                  .rolling_file("./log/buyma-insider-#{ENV['ENVIRONMENT']}.log",
                                                :age    => 'weekly',
                                                :layout => Logging.layouts.pattern(
                                                  :pattern => '[%d] %-5l -- %c : %m\n'))

worker           = Logging.logger['worker']
worker.level     = :info
worker.appenders = Logging.appenders
                     .rolling_file("./log/workers-#{ENV['ENVIRONMENT']}.log",
                                   :age    => 'weekly',
                                   :layout => Logging.layouts.pattern(
                                     :pattern => '[%d] %-5l -- %c : %m\n'))


