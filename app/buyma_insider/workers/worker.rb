require 'sidekiq'
require 'sidetiq'

module Worker
  class Base
    include ::Sidekiq::Worker
    include ::Sidetiq::Schedulable
  end
end
