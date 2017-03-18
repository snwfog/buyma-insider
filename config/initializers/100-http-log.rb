# 100+ ids are for development

HttpLog.configure do |cfg|
  cfg.logger = Logging.logger[:Httplog]
  class << cfg.logger
    def log(_severity, *args)
      debug(*args)
    end
  end
end
