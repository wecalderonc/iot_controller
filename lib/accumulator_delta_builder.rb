class AccumulatorDeltaBuilder

  # Limit value before accumulator's cycle is restarted
  CONSUMPTION_LIMIT = 0xffffffff  # => 4294967295

  GetConsumption = -> accumulator { accumulator.value.to_i(16) }  # => #<Proc:0x000056145f84dec8@/home/iot-one/code/iot_controller/lib/accumulator_delta_builder.rb:6 (lambda)>

  def call(accumulators)
    delta_accumulated = 0

    accumulators.map.with_index do |accumulator, index|

      current_value = GetConsumption.(accumulator)
      last_value = GetConsumption.(accumulators[index-1])

      if index == 0
        delta = 0
      elsif current_value < last_value
        delta = CONSUMPTION_LIMIT - last_value + current_value
      else
        delta = current_value - last_value
      end
      delta_accumulated += delta
      { delta: delta, accumulated: delta_accumulated }
    end
  end                                                           # => :call
end                                                             # => :call
