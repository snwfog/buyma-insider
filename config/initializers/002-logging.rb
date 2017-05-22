logging_cfg = BuymaInsider.configuration.logging.dup
logging_cfg.each do |layer, logger_cfg|
  # Root logger don't accept additive attribute and is false by default
  # When its root, not in prod and has tty?
  # - add a STDOUT appenders
  # - set severity to info
  if layer =~ /root/
    root_logger = Logging.logger.root
    if !BuymaInsider.production? || STDOUT.tty?
      root_logger.add_appenders(Logging.appenders.stdout(level: logger_cfg.severity))
    end
  else
    Logging.logger[layer.capitalize].tap do |logger|
      logger.level    = logger_cfg.severity
      logger.additive = logger_cfg.additive
      severity_cfg    = logger_cfg.level[logger_cfg.severity]
      logger.add_appenders(
        Logging.appenders.rolling_file(severity_cfg.location,
                                       age:    severity_cfg.age,
                                       layout: Logging.layouts.pattern(pattern: severity_cfg.pattern)))
    end
  end
end
