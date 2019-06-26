require 'dry/transaction/operation'

class Amazon::Iot::Api::ParseData
  include Dry::Transaction::Operation

  def call(input)
    data = JSON.parse input[:request][:payload].read
    input.merge(data: data)
  end
end
