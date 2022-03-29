# frozen_string_literal: true

class Filter
  attr_reader :name, :value, :type

  def initialize(name:, value:, type: nil)
    @name = name
    @value = value
    @type = type
  end

  def apply(result_set:)
    case @type
    when :like
      result_set.where(Sequel.like(@name.to_sym, "%#{@value}%"))
    when :in
      @value.each do |filter|
        result_set = result_set.where(Sequel.like(@name.to_sym, "%#{filter}%"))
      end
      result_set
    else
      result_set.where(@name.to_sym => @value)
    end
  end
end
