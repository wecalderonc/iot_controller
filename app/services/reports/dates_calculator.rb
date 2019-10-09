# This service get the initial date of current period
require 'dry/transaction/operation'

class Reports::DatesCalculator
  include Dry::Transaction::Operation

  def call(input)
    variables = get_location_variables(input[:thing].locates)
    result = extract_new_date(variables)

    Success input.merge(new_billing_start_date: result)

  end

  private

  def extract_new_date(start_date:, end_date:, frequency:, new_date:)
    if start_date > end_date
      new_date
    else
      new_date = start_date
      new_start_date = start_date + (frequency.months)

      extract_new_date(start_date: new_start_date, end_date: end_date, frequency: frequency, new_date: new_date)
    end
  end

  def get_location_variables(location)
    schedule_billing = location.schedule_billing

    { 
      start_date: schedule_billing.start_date,
      end_date: Time.now,
      frequency: schedule_billing.billing_frequency,
      new_date: 0
    }
  end
end
