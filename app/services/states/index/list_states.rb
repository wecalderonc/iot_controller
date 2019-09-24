require 'dry/transaction/operation'

class States::Index::ListStates
  include Dry::Transaction::Operation

  def call(input)
    input[:country].states.order(name: :asc)
  end
end
