module Calculators::WaterMetter

  LIMIT_VALUE = 0xffffffff

  #This function evaluates if is possible to cut in a number of counters
  ReadyForConsumption = -> last_accumulator, cut_in do
    (last_accumulator + cut_in) < LIMIT_VALUE
  end

  #This function evaluates if is possible to cut in a determinated value
  ReadyForAccValue = -> last_accumulator, cut_in do
    last_accumulator < cut_in
  end
end
