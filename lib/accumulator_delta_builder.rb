class AccumulatorDeltaBuilder

  # Limit value before accumulator's cycle is restarted
  CONSUMPTION_LIMIT = 0xffffffff

  GetConsumption = -> accumulator { accumulator.value.to_i(16) }

  def call(accumulators)
    delta_accumulated = 0
    accumulators.map.with_index do |accumulator, index|
      if index == 0
        delta = 0
      elsif GetConsumption.(accumulator) < GetConsumption.(accumulators[index-1])
        delta = CONSUMPTION_LIMIT - GetConsumption.(accumulators[index-1]) + GetConsumption.(accumulator)
      else
        delta = GetConsumption.(accumulator) - GetConsumption.(accumulators[index-1])
      end
      delta_accumulated += delta
      { delta: delta, accumulated: delta_accumulated }
    end
  end
end
