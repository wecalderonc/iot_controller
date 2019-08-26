require 'dry/transaction/operation'

class Things::Update::Update
  include Dry::Transaction::Operation

  def call(input)
    thing = input[:thing]

    if thing.update(input)
      Success input
    else
      Failure Errors.general_error(thing.errors.messages, self.class)
    end
  end
end
