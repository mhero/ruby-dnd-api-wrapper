# frozen_string_literal: true

require './database/connection'
require 'pry'

class Record
  def initialize(params: {})
    @connection = params[:connection] || Connection.new
    @database = @connection.database
  end

  def global_scope
    @database[table_name]
  end

  def count(scope: global_scope)
    scope.count
  end

  def insert(elements:)
    global_scope.insert_ignore.multi_insert(elements)
  end

  def group_and_count(group_by:, scope: global_scope)
    scope.group_and_count(*group_by)
  end

  def sort(groups:, scope: global_scope)
    scope.order_append(groups)
  end

  def all(scope: global_scope, page: 1, page_size: 10)
    scope.paginate(page, page_size).all
  rescue Sequel::DatabaseError, Sequel::Error => e
    puts e.message
  end

  def where(filters:, scope: global_scope)
    filters.inject(scope) { |result_set, filter| filter.apply(result_set:) }
  end
end
