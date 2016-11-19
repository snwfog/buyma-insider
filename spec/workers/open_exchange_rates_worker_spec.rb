require 'json'
require 'buyma_insider'
require 'minitest/autorun'
require 'rspec'

describe OpenExchangeRatesWorker do
  it 'should save latest exchange rates from oer' do
    stubbed_oer = Money::Bank::OpenExchangeRatesBank.new
    Money::Bank::OpenExchangeRatesBank.stub :new, stubbed_oer do
      def stubbed_oer.read_from_url
        JSON.generate({ timestamp: Time.now.utc.to_i,
                        base:      'USD',
                        rates:     { JYP: 1.0, CAD: 2.0 } })
      end

      oer = OpenExchangeRatesWorker.new.perform
      expect(oer.persisted?).to be true
    end
  end
end