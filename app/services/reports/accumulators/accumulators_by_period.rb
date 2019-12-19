require 'dry/transaction/operation'

class Reports::Accumulators::AccumulatorsByPeriod
  include Dry::Transaction::Operation
  include ModelModifiers

  def call(period)
    accumulators = ThingsQuery.new(period[:thing]).date_uplinks_filter(period[:date], :accumulator)
    Accumulator.delete_objects_with_property!(accumulators, :wrong_consumption)

    period.merge(accumulators: accumulators)
  end
end
