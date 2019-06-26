require 'dry/transaction/operation'

class Amazon::Iot::Api::RequestData
  include Dry::Transaction::Operation

  def call(input)
    opts = {
      :desired =>  Amazon::Iotdata::Api::Requesters::RequestUpdate.new,
      :reported => Amazon::Iotdata::Api::Requesters::RequestGet.new
    }

    opts[input[:type].to_sym].(input)
  end
end
