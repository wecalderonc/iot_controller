require 'dry/transaction/operation'

class Shadows::Update::BuildPayload
  include Dry::Transaction::Operation

  PAYLOAD = "0000000000010000"

  def call(input)
    {
      scheduled_cut: -> { scheduled_restore_or_cut_supply(input) },
      restore_supply: -> { restore_supply(input) },
      instant_cut: -> { instant_cut(input) },
      restore_supply_with_scheduled_cut: -> { scheduled_restore_or_cut_supply(input) },
    }[input[:action]].()
  end

  def instant_cut(input)
    thing = input[:thing]
    last_accumulator = input[:last_accumulator]
    payload = "000000" + "3" + last_accumulator[0..3] + "2" + last_accumulator[4..7]
    input.merge(payload: payload)
  end

  def restore_supply(input)
    input.merge(payload: PAYLOAD)
  end

  def scheduled_restore_or_cut_supply(input)
    value = input[:value]
    input_method = input[:input_method]&.to_sym
    last_accumulator = Base::Maths.hexa_to_int(input[:last_accumulator])

    if input_method.eql?(:accumulated_value)
      payload = PayloadBuilder.accumulate_value(value)
    else
      payload = PayloadBuilder.consume(value, last_accumulator)
    end

    input.merge(payload: payload)
  end
end
