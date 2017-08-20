require 'money/bank/open_exchange_rates_bank'

class OpenExchangeRatesWorker < Worker::Base
  def perform
    oer        = Money::Bank::OpenExchangeRatesBank.new
    oer.app_id = ENV['OPEN_EXCHANGE_RATES_API']
    oer.cache  = proc { |rates_text|
      rates_document = JSON.parse(rates_text)
      rates_document.select! { |k, v| %w(timestamp base rates).include? k }

      rates_timestamp = rates_document.fetch('timestamp')
      if ExchangeRate.find_by_timestamp(rates_timestamp)
        logger.warn "Exchange rates for timestamp: #{rates_timestamp} exists already!"
      else
        logger.info "Creating new exchange rates for #{rates_timestamp}."
        ExchangeRate.create!(rates_document)
      end
    }

    oer.save_rates
  end
end
