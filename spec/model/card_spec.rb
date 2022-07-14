# frozen_string_literal: true

require './model/card'
require './database/connection'
require './services/card_fetcher'
require './model/filter'

RSpec.describe Card do
  subject { described_class.new(params: { connection: Connection.new(enviroment: 'test') }) }
  let(:card_fetcher) { CardFetcher.new(total_pages: 1, thread_pool: 1) }
  let!(:cards) do
    [
      {
        uuid: '1',
        name: 'one',
        set: 'SET',
        setName: 'set',
        rarity: 'Uncommon',
        colors: %w[Red Blue]
      },
      {
        uuid: '2',
        name: 'two',
        set: 'SETX',
        setName: 'set',
        rarity: 'Uncommon',
        colors: %w[Red Blue White]
      },
      {
        uuid: '3',
        name: 'three',
        set: 'SET',
        setName: 'set',
        rarity: 'Uncommon',
        colors: %w[Red Blue Black]
      }
    ]
  end

  describe '#insert' do
    before do
      Connection.new(enviroment: 'test').database[:cards].delete
    end

    it 'saves the fetched cards into the database' do
      VCR.use_cassette(
        'cards_thread',
        match_requests_on: [:body],
        re_record_interval: @re_record_interval
      ) do
        card_fetcher.fetch_all
      end

      subject.insert(cards: card_fetcher.deck + cards)
      expect(subject.count).to eq(card_fetcher.deck.size + cards.size)
    end
  end

  describe '#where' do
    it 'returns a card with uuid' do
      query = subject.where(
        filters: [
          Filter.new(name: 'uuid', value: '5f8287b1-5bb6-5f4c-ad17-316a40d5bb0c')
        ]
      )
      expect(
        query.count
      ).to eq(1)
      expect(
        query.first[:uuid]
      ).to eq('5f8287b1-5bb6-5f4c-ad17-316a40d5bb0c')
    end

    it 'returns a cards with similar content' do
      query = subject.where(
        filters: [
          Filter.new(name: 'name', value: "Ancestor's", type: :like)
        ]
      )
      expect(
        query.count
      ).to eq(2)

      expect(
        query.all.map { |element| element[:name] }.uniq.first
      ).to eq('Ancestor\'s Chosen')
    end

    it 'returns a cards with content in array' do
      query = subject.where(
        filters: [
          Filter.new(name: 'colors', value: ['White'], type: :in)
        ]
      )

      expect(
        query.count
      ).to eq(93)

      expect(
        query.all.map { |element| element[:colors] }.uniq.first
      ).to eq('White')
    end
  end
end
