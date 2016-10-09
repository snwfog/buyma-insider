require 'sidekiq'
require 'logging'

Sidekiq::Logging.logger = Logging.logger[:Worker]

