require 'dry/transaction/operation'

class Reports::AverageConsumption
  include Dry::Transaction::Operation

  def call(input)
    dates = get_dates_variables(input[:thing].locates)
    value = 
    
  end

  private

  def get_dates_variables(location)
    {
      start_date: location.schedule_billing.start_date,
      frequency: location.schedule_billing.billing_frequency,
      last_acc: uplink.accumulator.last.created_at
    }

  end
end
