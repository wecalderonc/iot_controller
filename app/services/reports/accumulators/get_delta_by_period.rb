require 'dry/transaction/operation'

class Reports::Accumulators::GetDeltaByPeriod
  include Dry::Transaction::Operation

  def call(period)
    accumulators = period[:accumulators][period[:thing]]

    if accumulators.present?
      deltas =  AccumulatorDeltaBuilder.new.(accumulators)
      delta = deltas[-1][:accumulated]
    end

    period.merge(value: delta || 0)
  end
end
