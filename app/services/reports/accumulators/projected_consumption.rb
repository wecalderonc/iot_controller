# This service follow the nex equation y=mx+b
require 'dry/transaction/operation'

class Reports::Accumulators::ProjectedConsumption
  include Dry::Transaction::Operation

  HOURS = 24
  MINUTES = 60
  CURRENT_PERIOD = "4"

  DaysToMin = -> days do
    days * HOURS * MINUTES
  end

  GetProjectedDays = -> thing do
    frequency = thing.locates.schedule_billing.billing_frequency
    frequency.months / 1.days
  end

  def call(input)
    consumption, days = input[:consumptions_by_month][CURRENT_PERIOD].values_at(:value, :days_count)
    average = average_consumption(consumption, days)

    calculate_projected({
      average: average,
      cut_point: cut_point_y(consumption, average, days),
      days: days,
      input: input
    })
  end

  private

  def average_consumption(value, days)
    value / DaysToMin.(days).to_f
  end

  def cut_point_y(value, average, days)
    value - average * DaysToMin.(days)
  end

  def calculate_projected(cut_point:, average:, days:, input:)
    projected_days = GetProjectedDays.(input[:thing])
    minutes = DaysToMin.(projected_days)

    proyected = average * minutes + cut_point

    input.merge(projected_consumption: { days_count: projected_days - days, value: proyected })
  end
end
