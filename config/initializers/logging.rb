require 'logging'

Logging.logger.root.level = :info
Logging.logger.root.add_appenders(Logging.appenders
                                    .stdout("./log/workers-#{ENV['ENVIRONMENT']}.log",
                                            :layout => Logging.layouts.pattern(
                                              :pattern => '[%d] %-5l -- %c : %m\n')))

Logging.logger.root.add_appenders(Logging.appenders
                                    .rolling_file("./log/buyma-insider-#{ENV['ENVIRONMENT']}.log",
                                                  :age    => 'weekly',
                                                  :layout => Logging.layouts.pattern(
                                                    :pattern => '[%d] %-5l -- %c : %m\n')))



