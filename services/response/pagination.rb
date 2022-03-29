# frozen_string_literal: true

module Response
  class Pagination
    attr_reader :total_count, :page_size, :total_pages

    def initialize(headers:)
      @total_count = headers['total-count'].to_i
      @page_size = headers['page-size'].to_i
      @total_pages = (total_count.to_f / page_size)
    end
  end
end
