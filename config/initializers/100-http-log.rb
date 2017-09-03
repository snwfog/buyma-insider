HttpLog.configure do |cfg|
  cfg.logger      = Logging.logger[:Httplog]
  cfg.log_headers = true
  cfg.color       = true
  class << cfg.logger
    def log(_severity, *args)
      debug(*args)
    end
  end
end
