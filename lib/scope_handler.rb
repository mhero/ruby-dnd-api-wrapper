# frozen_string_literal: true

class ScopeHandler
  def initialize(card:)
    @card = card
    @filters = []
  end

  def filter_by_set(set:)
    @filters << Filter.new(name: 'set', value: set)
  end

  def filter_by_set_name(set_name:)
    @filters << Filter.new(name: 'set_name', value: set_name)
  end

  def filter_by_colors(colors:)
    @filters << Filter.new(name: 'colors', value: colors, type: :in)
  end

  def filter_by_colors_exclusive(colors:)
    @filters.append(
      Filter.new(name: 'colors_quantity', value: colors.size),
      Filter.new(name: 'colors', value: colors, type: :in)
    )
  end

  def scope
    @card.where(filters: @filters)
  end

  def sort(groups:)
    @card.sort(groups:, scope:)
  end

  def all(page: 1, page_size: 10)
    @card.all(scope:, page:, page_size:)
  end

  def count
    scope.count
  end
end
