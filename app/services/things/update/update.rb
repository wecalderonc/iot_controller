require 'dry/transaction/operation'

class Things::Update::Update
  include Dry::Transaction::Operation

  def call(input)
    p "DENTRO DE THINGS::UPDATE::UPDATEEE ***************"
    thing = input[:thing]
    p input
    p input[:params]
    if thing.update({name: "guajira"})
      p "SUCCESS"
      Success input
    else
      p "FAILURE"
      Failure Errors.general_error(thing.errors.messages, self.class)
    end
  end
end
