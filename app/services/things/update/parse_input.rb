require 'dry/transaction/operation'

class Deliveries::Update::ParseInput
  include Dry::Transaction::Operation

  def call(input)
    input.merge(params: input[:params].to_h)
  end
end
