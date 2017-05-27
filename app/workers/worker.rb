require 'sidekiq'

module Worker
  class Base
    include ::Sidekiq::Worker
  end
end
