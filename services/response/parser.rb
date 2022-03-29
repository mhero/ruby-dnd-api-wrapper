# frozen_string_literal: true

require 'json'

module Response
  class Parser
    EMPTY_RESPONSE = {}.freeze

    def initialize(response:)
      @response = response
    end

    def parse
      return EMPTY_RESPONSE if @response.nil?

      json_response = JSON.parse(@response.body, { symbolize_names: true })
      json_response[:cards]
    rescue JSON::ParserError, NoMethodError => e
      puts "One request failed please check logs: #{e.message}"
      EMPTY_RESPONSE
    end
  end
end
