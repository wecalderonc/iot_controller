require 'dry/transaction/operation'

class Cities::Index::ListCities
  include Dry::Transaction::Operation

  def call(input)
    input[:state].cities.order(name: :asc)
  end
end
