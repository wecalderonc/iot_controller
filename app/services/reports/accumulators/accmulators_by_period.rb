require 'dry/transaction/operation'

class Reports::Accumulators::AccumulatorsByPeriod
  include Dry::Transaction::Operation

  def call(period)
    accumulators = ThingsQuery.new(period[:thing]).date_uplinks_filter(period[:date], :accumulator)

    period.merge(accumulators: accumulators)
  end
end
