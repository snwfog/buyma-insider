require 'money/bank/open_exchange_rates_bank'

class OpenExchangeRatesWorker < Worker::Base
  def perform
    oer        = Money::Bank::OpenExchangeRatesBank.new
    oer.app_id = ENV['OPEN_EXCHANGE_RATES_API']
    oer.cache  = proc { |rates_text|
      rates_document = JSON.parse(rates_text)
      rates_document.select! { |k, _v| %w(timestamp base rates).include? k }
      rates_timestamp_utc = Time.at(rates_document.fetch('timestamp')).utc
      if ExchangeRate.find_by_timestamp(rates_timestamp_utc)
        logger.warn "Exchange rates for timestamp #{rates_timestamp_utc} already record."
      else
        logger.info "Creating new exchange rates for #{rates_timestamp_utc}."
        ExchangeRate.create!(rates_document)
      end
    }

    oer.save_rates
  rescue => ex
    Raven.capture_exception(ex)
  end
end
