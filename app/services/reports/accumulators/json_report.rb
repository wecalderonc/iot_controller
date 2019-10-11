require 'dry/transaction/operation'

class Reports::Accumulators::JsonReport
  include Dry::Transaction::Operation

  def call(input)
    historical = input.slice(:consumptions_by_month)
    report = Reports::BaseJsonReport.new.(input)[0]

    report.merge!(historical)
  end
end
