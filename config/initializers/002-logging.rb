app_log_cfg  = BuymaInsider.configuration.log.sinatra
severity     = app_log_cfg.severity
severity_cfg = app_log_cfg.level[severity]
layout       = Logging.layouts.pattern(pattern: severity_cfg.pattern)

Logging.logger.root.level = severity

Logging.logger.root.add_appenders(
  Logging.appenders.stdout(layout: layout,
                           level:  :info)) # STDOUT is always default to info

Logging.logger.root.add_appenders(
  Logging.appenders.rolling_file(severity_cfg.location,
                                 age:    'daily',
                                 layout: layout,
                                 level:  severity))

Logging.logger.root.add_appenders(
  Logging.appenders.rolling_file(app_log_cfg.level.debug.location,
                                 age:    'daily',
                                 layout: layout,
                                 level:  :debug))
