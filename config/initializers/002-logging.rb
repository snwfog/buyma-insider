layout     = Logging.layouts.pattern(pattern: '[%d] %-5l -- %c : %m\n')
log_path   = File.expand_path("../../../log/buyma-insider-#{ENV['RACK_ENV']}.log", __FILE__)
debug_path = File.expand_path("../../../log/buyma-insider-debug-#{ENV['RACK_ENV']}.log", __FILE__)

Logging.logger.root.level = :info

Logging.logger.root.add_appenders(
  Logging.appenders.stdout(layout: layout,
                           level:  :info))

Logging.logger.root.add_appenders(
  Logging.appenders.rolling_file(log_path,
                                 age:    'daily',
                                 layout: layout,
                                 level:  :info))

Logging.logger.root.add_appenders(
  Logging.appenders.rolling_file(debug_path,
                                 age:    'daily',
                                 layout: layout,
                                 level:  :debug))
