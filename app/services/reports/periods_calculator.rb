module Reports

  GetDaysPeriod = -> period do
    start_date, end_date = period[:date].values_at(:start_date, :end_date)
    months = (start_date..end_date).map(&:month).uniq

    period.merge!(days_count: (end_date - start_date).to_i, months: months)
  end

  ConvertToEpoch = -> period do
    dates = period[:date]

    dates.each do |type, date|
      dates[type] = date.to_time.to_i.to_s
    end
  end

  GetDelta = -> period do
    accumulators = period[:accumulators][period[:thing]]

    if accumulators.present?
      deltas =  AccumulatorDeltaBuilder.new.(accumulators)
      delta = deltas[-1][:accumulated]
    end

    period.merge!(value: delta || 0)
  end

  GetAccumulators = -> period do
    accumulators = ThingsQuery.new(period[:thing]).date_uplinks_filter(period[:date], :accumulator)

    period.merge!(accumulators: accumulators)
  end

  ParseResult = -> period do
    period.slice(:value, :days_count, :months)
  end

  _, PeriodsCalculator = Common::TxMasterBuilder.new do
    map  :get_days_period,       with: GetDaysPeriod
    tee  :convert_date_to_epoch, with: ConvertToEpoch
    map  :get_accumulators,      with: GetAccumulators
    map  :get_delta,             with: GetDelta
    map  :convert_value,         with: Reports::ValueConverter.new
    map  :parse_result,          with: ParseResult
  end.Do
end
