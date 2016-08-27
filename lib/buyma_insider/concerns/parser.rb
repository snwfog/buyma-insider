require 'nokogiri'

module Concerns
  module Parser
    ##
    # Parse the response HTML string into Nokogiri HTML document
    #
    def parse
      if @response.nil?
        raise 'Response variable must be available'
      else
        @document = Nokogiri::HTML(@response.body)
      end
    end
  end
end