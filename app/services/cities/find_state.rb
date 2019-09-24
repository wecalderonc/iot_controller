require 'dry/transaction/operation'

class Cities::FindState
  include Dry::Transaction::Operation

  def call(input)
    state = State.find_by(code_iso: input[:state_code])

    if state.present?
      Success input.merge(state: state)
    else
      Failure Errors.service_error("State not found", 10104, self.class)
    end
  end
end
