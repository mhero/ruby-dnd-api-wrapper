# frozen_string_literal: true

require 'sequel'
require 'sqlite3'
require './model/record'

class Card < Record
  def table_name
    :cards
  end

  def insert(cards:)
    super(elements: filtered_cards(cards:))
  end

  private

  def filtered_cards(cards:)
    cards.map do |card|
      {
        uuid: card[:id],
        name: card[:name],
        set: card[:set],
        set_name: card[:setName],
        rarity: card[:rarity],
        colors: (card[:colors] || []).join(','),
        colors_quantity: (card[:colors] || []).size
      }
    end
  end
end
