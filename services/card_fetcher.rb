# frozen_string_literal: true

require './model/card'
require './services/http_client'

class CardFetcher
  attr_reader :deck, :failed_pages

  DEFAULT_CARD_ENDPOINT = 'cards'

  def initialize(total_pages: nil, thread_pool: nil)
    @total_pages = total_pages(total_pages:)

    @thread_pool = thread_pool || 20
    @pages_iteration = (@total_pages / @thread_pool).to_f.ceil
    @deck = []
    @failed_pages = []
  end

  def fetch_all
    @pages_iteration.times do |iteration|
      fetch_multithread(iteration:)
    end
  end

  def retry_failed
    @failed_pages.each do |page|
      http_thread_call(page:)
    end.each(&:join)
  end

  private

  def total_pages(total_pages:)
    pagination = HttpClient.new.pagination(endpoint: DEFAULT_CARD_ENDPOINT)
    total_pages || pagination.total_pages
  end

  def fetch_multithread(iteration:)
    @thread_pool.times.map do |pool|
      page = (@thread_pool * iteration) + (pool + 1)

      http_thread_call(page:)
    end.each(&:join)
  end

  def http_thread_call(page:)
    Thread.new(@deck, @failed_pages, page) do |deck, failed_pages, page|
      Mutex.new.synchronize do
        cards = HttpClient.new.fetch(endpoint: DEFAULT_CARD_ENDPOINT, page:)
        deck.push(*cards) if cards.size.positive?
        failed_pages << page if cards.size.zero?
      end
    end
  end
end
