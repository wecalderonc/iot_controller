require 'dry/transaction/operation'

class Reports::PeriodsCalculator
  include Dry::Transaction::Operation

  def call(input)
    new_date = input[:new_billing_start_date]
    frequency = input[:thing].locates.schedule_billing.billing_frequency

    4.times do
      last_day = new_date
      period_start_date = input[:new_billing_start_date] - frequency.month
      period_end_date = last_day - 1.day
    end
  end
end
