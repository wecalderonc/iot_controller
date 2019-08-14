class AccumulatorSerializer < UplinkBaseSerializer
  attributes  :units_count, :final_price

  def units_count
    price_info[:units_count]
  end

  def final_price
    price_info[:final_price]
  end

  private

  def price_info
    if self.object.class.eql?(Accumulator)
      calculator_service = Calculators::Prices::Execute.new
      result = calculator_service.(unit: :liters, accumulator: self.object)
      if result.success?
        result.success
      else
        result.failure
      end
    else
      {}
    end
  end
end
