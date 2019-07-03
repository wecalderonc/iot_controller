module PayloadBuilder
  def self.consume(value, last_accumulator)
    sum =  Base::Maths.hexa_to_int(value) + last_accumulator
    sum_string = sum.to_s(16)

    self.accumulate_value(sum_string.rjust(8,'0'))
  end

  def self.accumulate_value(value)
    "0" + "10000" + "3" + value[0..3] + "2" + value[4..7]
  end
end
