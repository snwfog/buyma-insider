require 'logging'

Logging.logger.root.level = :info
Logging.logger.root.add_appenders(Logging.appenders
                                    .stdout(:layout => Logging.layouts.pattern(
                                      :pattern => '[%d] %-5l -- %c : %m\n')))

Logging.logger.root.add_appenders(Logging.appenders
                                    .rolling_file("./log/buyma-insider-#{ENV['ENVIRONMENT']}.log",
                                                  :age    => 'weekly',
                                                  :layout => Logging.layouts.pattern(
                                                    :pattern => '[%d] %-5l -- %c : %m\n')))


worker          = Logging.logger['Worker']
worker.level    = :info
worker.additive = false

worker.add_appenders(Logging.appenders
                       .stdout(:layout => Logging.layouts.pattern(
                         :pattern => '[%d] %-5l -- %c : %m\n')))

worker.add_appenders(Logging.appenders
                       .rolling_file("./log/workers-#{ENV['ENVIRONMENT']}.log",
                                     :age    => 'weekly',
                                     :layout => Logging.layouts.pattern(
                                       :pattern => '[%d] %-5l -- %c : %m\n')))

