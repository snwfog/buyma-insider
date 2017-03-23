logging_cfg = BuymaInsider.configuration.logging.dup

# Create logging for all layers of application
set_logging_configuration = -> (cfg, logger) do
  logger.level    = cfg.severity
  logger.additive = cfg.additive unless logger.is_a?(Logging::RootLogger)
  severity_cfg    = cfg.level[cfg.severity]
  logger.add_appenders(
    Logging.appenders.rolling_file(severity_cfg.location,
                                   age:    severity_cfg.age,
                                   layout: Logging.layouts.pattern(pattern: severity_cfg.pattern)))
end

# Get root logger
Logging.logger.root.tap do |logger|
  root_cfg = logging_cfg.delete(:root)
  # Root logger don't accept additive attribute and is false by default
  set_logging_configuration.call(root_cfg, logger)
  if (BuymaInsider.development? || BuymaInsider.test?) && STDOUT.tty?
    logger.add_appenders(Logging.appenders.stdout)
  end
end

logging_cfg.each do |layer, logger_cfg|
  Logging.logger[layer.capitalize].tap { |logger| set_logging_configuration.call(logger_cfg, logger) }
end
