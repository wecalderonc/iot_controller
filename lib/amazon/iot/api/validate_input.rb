require 'dry/transaction/operation'

class Amazon::Iot::Api::ValidateInput
  include Dry::Transaction::Operation

  def call(input)
    {
      :desired =>  Amazon::Iotdata::Api::Validators::ValidateDesired.new,
      :reported => Amazon::Iotdata::Api::Validators::ValidateReported.new
    }[input[:type].to_sym].(input)
  end
end
