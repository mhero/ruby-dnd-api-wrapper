# frozen_string_literal: true

require './model/card'
require './database/connection'
require './model/filter'
require './lib/scope_handler'

RSpec.describe ScopeHandler do
  let!(:card) { Card.new(params: { connection: Connection.new(enviroment: 'test') }) }
  subject { described_class.new(card:) }

  describe 'scopes returning values' do
    it 'returns the cards filter by set' do
      subject.filter_by_set(set: 'SET')
      expect(
        subject.scope.all.count
      ).to eq(2)
    end

    it 'returns the cards filter by set and color' do
      subject.filter_by_set(set: 'SET')
      subject.filter_by_colors(colors: ['Red'])
      expect(
        subject.scope.all.count
      ).to eq(2)
    end

    it 'returns the cards filter by set and color(explicit list)' do
      subject.filter_by_set(set: 'SET')
      subject.filter_by_colors_exclusive(colors: %w[Red Blue])
      expect(
        subject.scope.all.count
      ).to eq(1)
    end

    it 'returns the cards filter by set and color(explicit list)' do
      subject.filter_by_set_name(set_name: 'set')
      subject.sort(groups: [:set])
      result_set = subject.scope.all
      expect(
        result_set.count
      ).to eq(3)
      expect(
        result_set.map { |card| card[:set] }
      ).to match_array(%w[SET SET SETX])
    end
  end
end
