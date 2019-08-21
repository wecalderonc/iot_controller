require 'dry/transaction'

class Locations::Create::AssignState
  include Dry::Transaction

  FindState = -> input do
    State.find_by(code_iso: input[:state], country: input[:country])
  end

  def call(input)
    state = FindState.(input[:country_state_city])

    if state.present?
      input[:country_state_city][:state] = state

      Success input
    else
      Failure Errors.general_error("State not found", self.class)
    end
  end
end
