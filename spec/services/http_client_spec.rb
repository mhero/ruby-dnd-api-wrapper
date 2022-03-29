# frozen_string_literal: true

require './services/http_client'

RSpec.describe HttpClient do
  subject { described_class.new(base_url: 'https://api.magicthegathering.io/v1/') }

  describe '#fetch' do
    it 'fetches a correct response from knwon API' do
      VCR.use_cassette(
        'cards',
        match_requests_on: [:body],
        re_record_interval: @re_record_interval
      ) do
        expect(subject.fetch(endpoint: 'cards').size).to eq(100)
      end
    end
  end

  describe '#pagination' do
    it 'fetches hedaers from knwon API' do
      VCR.use_cassette(
        'cards',
        match_requests_on: [:body],
        re_record_interval: @re_record_interval
      ) do
        expect(subject.pagination(endpoint: 'cards')).not_to be_nil
      end
    end
  end
end
