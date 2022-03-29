# frozen_string_literal: true

class CardDownloader
  LOG_FILE = 'log.txt'

  def initialize(card:)
    @card_fetcher = CardFetcher.new
    @card = card
  end

  def download_and_save
    puts 'Downloading API to databbse...'
    @card_fetcher.fetch_all
    save
    save_log
    puts 'Download and store completed.'
  end

  private

  def save
    @card.insert(cards: @card_fetcher.deck)
  end

  def save_log
    File.write(LOG_FILE, @card_fetcher.failed_pages.join("\n"))
  end
end
