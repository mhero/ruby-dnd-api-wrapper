# frozen_string_literal: true

require 'optparse'
require './services/card_fetcher'
require './database/setup'
require './model/filter'
require './model/card'
require './lib/input_parser'
require './services/card_downloader'
require './lib/scope_handler'
require 'pry'
require 'awesome_print'

include InputParser

@options = {
  page: 1,
  print_scope: false,
  page_size: 10,
  fomatted: true
}

card = Card.new
scope = ScopeHandler.new(card:)

OptionParser.new do |opts|
  opts.on('-n', '--setup', 'Sets up dataase') do
    puts 'Setting up ...'
    Setup.new.call
    puts 'Set up complete'
  end

  opts.on('-d', '--download', 'Downloads the API to a local database') do
    CardDownloader.new(card:).download_and_save
  end

  opts.on('-s', '--set set', 'Filter results by set') do |set|
    scope.filter_by_set(set:)
    @options[:print_scope] = true
  end

  opts.on('-c', '--colors c1,c2', 'Filter results by colors') do |colors|
    scope.filter_by_colors(colors: parse_colors(colors))
    @options[:print_scope] = true
  end

  opts.on('-x', '--colors-exclusive c1,c2', 'Filter results by colors(with only those colors)') do |colors|
    scope.filter_by_colors_exclusive(colors: parse_colors(colors))
    @options[:print_scope] = true
  end

  opts.on('-g', '--group-by g1,g2', 'Groups results by field') do |groups|
    scope.sort(groups: parse_groups(groups))
    @options[:print_scope] = true
  end

  opts.on('-p', '--page page', 'Page number') do |page|
    @options[:page] = parse_page(page)
  end

  opts.on('-f', '--fomatted false', 'Show pretty print version') do |formatted|
    @options[:fomatted] = parse_format(formatted)
  end

  opts.on('-h', '--help', 'Shows help') do
    puts opts
    exit
  end
end.parse!

if @options[:print_scope]
  puts "page #{@options[:page]} of #{(scope.count.to_f / @options[:page_size]).ceil}"
  results = scope.all(page: @options[:page], page_size: @options[:page_size])
  @options[:fomatted] ? (ap results) : (p results)
end
