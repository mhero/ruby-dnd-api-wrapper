# frozen_string_literal: true

require 'faraday'
require './services/response/parser'
require './services/response/pagination'

class HttpClient
  DEFAULT_TIMEOUT = 6 # seconds
  DEFAULT_BASE_URL = 'https://api.magicthegathering.io/v1/'

  def initialize(base_url: nil)
    @connection = Faraday.new(
      url: base_url || DEFAULT_BASE_URL,
      headers: { 'Content-Type' => 'application/json' },
      request: { timeout: DEFAULT_TIMEOUT }
    ) do |conn|
      conn.adapter Faraday.default_adapter
    end
  end

  def pagination(endpoint:)
    Response::Pagination.new(
      headers: @connection.get(endpoint).headers
    )
  end

  def fetch(endpoint:, page: 1)
    begin
      response = @connection.get(endpoint, page:)
    rescue Faraday::TimeoutError
      puts 'Timeout error'
    rescue Faraday::ConnectionFailed
      puts 'Connection failed'
    end
    Response::Parser.new(response:).parse
  end
end
