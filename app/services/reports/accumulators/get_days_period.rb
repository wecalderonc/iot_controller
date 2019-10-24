require 'dry/transaction/operation'

class Reports::Accumulators::GetDaysPeriod
  include Dry::Transaction::Operation

  def call(period)
    start_date, end_date = period[:date].values_at(:start_date, :end_date)
    p start_date
    p end_date
    months = (start_date..end_date).map(&:month).uniq

    period.merge(days_count: (end_date - start_date).to_i, months: months)
  end
end
