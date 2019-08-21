require 'dry/transaction/operation'

class Locations::ParseDate
  include Dry::Transaction::Operation

  RemoveUnusedKeys = -> input do
    input.except!(:start_year, :start_month, :start_day)
  end

  def call(input)
    input[:start_date] = DateTime.new(input[:start_year], input[:start_month], input[:start_day])
    RemoveUnusedKeys.(input)
  end
end
