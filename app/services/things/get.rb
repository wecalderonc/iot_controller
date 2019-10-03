require 'dry/transaction/operation'

class Things::Get
  include Dry::Transaction::Operation

  def call(input)
    thing = Thing.find_by(name: input[:thing_name])

    if thing.present?
      Success input.merge(thing: thing)
    else
      Failure Errors.service_error("The thing #{input[:thing_name]} does not exist", 10104, self.class)
    end
  end
end
