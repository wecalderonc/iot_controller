require 'dry/transaction/operation'

class Locations::ParseInput
  include Dry::Transaction::Operation

  def call(input)
    parse_schedule_billing(input[:schedule_billing])
    parse_schedule_report(input[:schedule_report])
  end

  private

  def parse_schedule_billing(fields)
    fields.tap do |field|
      field[:billing_period] = field[:billing_period].to_sym
    end
  end

  def parse_schedule_report(fields)
    fields.tap do |field|
      field[:frequency_interval] = field[:frequency_interval].to_sym
    end
  end
end
