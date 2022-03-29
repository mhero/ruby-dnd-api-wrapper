# frozen_string_literal: true

require 'sequel'
require 'sqlite3'
require 'yaml'

class Setup
  def initialize
    @database_yaml = YAML.load_file('./database/database.yml')
  end

  def call
    @database_yaml.each do |_key, value|
      database = Sequel.sqlite(value['database'])
      database.create_table! :cards do
        primary_key :id
        String :uuid
        String :name, default: nil
        String :set, default: nil
        String :set_name, default: nil
        String :rarity, default: nil
        String :colors, default: nil
        String :colors_quantity, default: 0
      end
    end
  end
end
