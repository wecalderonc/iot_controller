require 'dry/transaction/operation'

class Amazon::Iot::Shadows::Update::BuildPayload
  include Dry::Transaction::Operation

  def call(input)
  end

  def instant_cut(input)
    thing = input[:thing]
    last_accumulator = thing.acumulators.last.value
    payload = "000000" + "3" + last_accumulator[0..3] + "2" + last_accumulator[4..7]
    input.merge(payload: payload)
  end
end
