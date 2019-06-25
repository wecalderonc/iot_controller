class AccumulatorDeltaBuilder

  LIMIT = 0xffffffff

  ToInt = -> accumulator { accumulator.value.to_i(16) }

  def call(input)
    accumulated = 0
    input.map.with_index do |accumulator, index|
      if index == 0
        delta = 0
      elsif ToInt.(accumulator) < ToInt.(input[index-1])
        delta = LIMIT - ToInt.(input[index-1]) + ToInt.(accumulator)
      else
        delta = ToInt.(accumulator) - ToInt.(input[index-1])
      end
      accumulated += delta
      { delta: delta, accumulated: accumulated }
    end
  end
end
