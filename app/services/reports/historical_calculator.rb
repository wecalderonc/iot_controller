require 'dry/transaction/operation'

class Reports::HistoricalCalculator
  include Dry::Transaction::Operation

  LAST_PERIODS = [ '3', '2', '1' ]

  def call(input)
    periods = calculate_dates(input)
    historical = get_historical(periods)
    input.merge(consumptions_by_month: historical)
  end

  private

  def calculate_dates(input)
    periods = { '4' => build_response(input[:new_billing_start_date], Date.today, input) }

    LAST_PERIODS.each do |number|
      last_period = (number.to_i + 1).to_s
      last_date = periods[last_period].dig(:date, :start_date)

      periods[number] = build_response(last_date - 1.month, last_date - 1.day, input)
    end

    periods
  end

  def get_historical(periods)
    periods.each do |number, period|
      periods[number] = Reports::PeriodsCalculator.new.(period).success
    end
  end

  def build_response(start_date, end_date, input)
    thing, unit = input.values_at(:thing, :unit)

    { 
      date: {
        start_date: start_date,
        end_date: end_date
      },
      thing: thing,
      accumulator: thing.uplinks.accumulator.last,
      unit: unit
    }
  end
end
