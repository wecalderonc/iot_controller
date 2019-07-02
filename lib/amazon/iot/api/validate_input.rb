require 'dry/transaction/operation'

class Amazon::Iot::Api::ValidateInput
  include Dry::Transaction::Operation

  def call(input)
    {
      desired:  Common::Operations::Validator.(:update_state, input[:action]),
      reported: Common::Operations::Validator.(:update_state, input[:type])
    }[input[:type].to_sym].(input)
  end
end
