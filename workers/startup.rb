require 'sidekiq'
require 'logging'
require 'require_all'
require 'buyma_insider'

worker       = Logging.logger['Worker']
worker.level = :info

worker.add_appenders(Logging.appenders
                       .stdout("./log/workers-#{ENV['ENVIRONMENT']}.log",
                               :layout => Logging.layouts.pattern(
                                 :pattern => '[%d] %-5l -- %c : %m\n')))

worker.add_appenders(Logging.appenders
                       .rolling_file("./log/workers-#{ENV['ENVIRONMENT']}.log",
                                     :age    => 'weekly',
                                     :layout => Logging.layouts.pattern(
                                       :pattern => '[%d] %-5l -- %c : %m\n')))

Sidekiq::Logging.logger = worker
require_all './workers'

