module Merchant
  class Ssense
    locations = [
      'https://www.ssense.com/en-ca/men',
      'https://www.ssense.com/en-ca/women'
    ]

    def crawl
      locations.each do |address|
        puts 'Crawling ssense'.blue
        # response = RestClient.get address
      end
    end
  end
end
