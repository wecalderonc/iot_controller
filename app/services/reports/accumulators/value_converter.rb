require 'dry/transaction/operation'

class Reports::Accumulators::ValueConverter
  include Dry::Transaction::Operation

  def call(period)
    response = Calculators::Prices::Execute.new.(period)

    value = response.success? ? response.success[:units_count] : 0
    period.merge(value: value || 0)
  end
end
