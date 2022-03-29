# frozen_string_literal: true

module InputParser
  def parse_colors(colors)
    split_colors = colors.split(',')
    split_colors.map do |color|
      color.split(/([[:alpha:]]+)/).map(&:capitalize).join
    end
  end

  def parse_groups(groups)
    split_groups = groups.split(',')
    split_groups.map(&:to_sym)
  end

  def parse_page(page)
    page.to_i
  end

  def parse_format(format)
    format.to_s.downcase == 'true'
  end
end
