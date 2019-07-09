require 'dry/transaction/operation'

class Shadows::Update::BuildPayload
  include Dry::Transaction::Operation

  PAYLOAD = "0000000000010000"

  def call(input)
    params = {
      scheduled_cut: -> { scheduled_restore_or_cut_supply(input) },
      restore_supply: -> { restore_supply(input) },
      instant_cut: -> { instant_cut(input) },
      restore_supply_with_scheduled_cut: -> { scheduled_restore_or_cut_supply(input) },
    }[input[:action_type]].()

    params.merge(type: :desired)
  end

  def instant_cut(input)
    thing = input[:thing]
    last_accumulators = input[:last_accumulators]
    payload = "000000" + "3" + last_accumulators[0..3] + "2" + last_accumulators[4..7]
    input.merge(payload: payload)
  end

  def restore_supply(input)
    input.merge(payload: PAYLOAD)
  end

  def scheduled_restore_or_cut_supply(input)
    value = input[:value]
    input_method = input[:input_method]&.to_sym
    last_accumulators = Base::Maths.hexa_to_int(input[:last_accumulators])

    if input_method.eql?(:accumulated_value)
      payload = PayloadBuilder.accumulate_value(value)
    else
      payload = PayloadBuilder.consume(value, last_accumulators)
    end

    input.merge(payload: payload)
  end
end
