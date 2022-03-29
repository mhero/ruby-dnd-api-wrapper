# frozen_string_literal: true

require './services/card_fetcher'

RSpec.describe CardFetcher do
  subject { described_class.new(total_pages: 1, thread_pool: 1) }

  describe '#fetch_all' do
    it 'fetches a correct response from knwon API' do
      VCR.use_cassette(
        'cards_thread',
        match_requests_on: [:body],
        re_record_interval: @re_record_interval
      ) do
        subject.fetch_all
      end
      expect(subject.deck.size).to eq(100)
    end
  end
end
