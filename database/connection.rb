# frozen_string_literal: true

class Connection
  attr_reader :database

  def initialize(enviroment: 'development')
    @database = Sequel.connect(
      adapter: 'sqlite',
      database: "database/#{enviroment}.sqlite3"
    )
    @database.extension(:pagination)
  end
end
