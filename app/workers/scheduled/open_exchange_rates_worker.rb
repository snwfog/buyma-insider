require 'money/bank/open_exchange_rates_bank'

class OpenExchangeRatesWorker < Worker::Base
  def perform
    oer        = Money::Bank::OpenExchangeRatesBank.new
    oer.app_id = ENV['OPEN_EXCHANGE_RATES_API']
    oer.cache  = proc { |rates_text|
      rates_document = JSON.parse(rates_text)
      rates_document.select! { |k, v| %w(timestamp base rates).include? k }
      ExchangeRate.create!(rates_document)
    }
    
    oer.save_rates
  end
end
