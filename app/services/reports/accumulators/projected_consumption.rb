# This service follow the nex equation y=mx+b
require 'dry/transaction/operation'

class Reports::Accumulators::ProjectedConsumption
  include Dry::Transaction::Operation

  DaysToMin = -> days do
    days * 24 * 60
  end

  GetProjectedDays = -> input do
    freq = input.locates.schedule_billing.billing_frequency
    freq.months / 1.days
  end

  def call(input)
    consumption, days = input[:consumptions_by_month]["4"].values_at(:value, :days_count)
    average = average_consumption(consumption, days)

    calculate_projected({
      average: average,
      cut_point: cut_point_y(consumption, average, days),
      days: days,
      input: input
    })
  end

  private

  # This method returns m
  def average_consumption(value, days)
    value/DaysToMin.(days).to_f
  end

  # This method returns b
  def cut_point_y(value, average, days)
    value - average * DaysToMin.(days)
  end

  # This method returns y
  def calculate_projected(cut_point:, average:, days:, input:)
    projected_days = GetProjectedDays.(input[:thing]) # period days
    minutes = DaysToMin.(projected_days)

    proyected = average * minutes + cut_point

    input.merge(projected_consumption: { days_count: projected_days - days, value: proyected })
  end
end
