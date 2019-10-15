module Reports::Accumulators

  ParseResult = -> period do
    period.slice(:value, :days_count, :months)
  end

  _, PeriodsCalculator = Common::TxMasterBuilder.new do
    map  :get_days_period,       with: Reports::Accumulators::GetDaysPeriod.new
    tee  :convert_date_to_epoch, with: Reports::Accumulators::ConvertToEpoch.new
    map  :get_accumulators,      with: Reports::Accumulators::AccumulatorsByPeriod.new
    map  :get_delta,             with: Reports::Accumulators::GetDeltaByPeriod.new
    map  :convert_value,         with: Reports::Accumulators::ValueConverter.new
    map  :parse_result,          with: ParseResult
  end.Do
end
