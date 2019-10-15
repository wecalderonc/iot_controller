require 'dry/transaction/operation'

class Reports::Accumulators::JsonReport
  include Dry::Transaction::Operation

  def call(input)
    data = input.slice(:consumptions_by_month, :projected_consumption)
    report = Reports::BaseJsonReport.new.(input)[0]

    report.merge(data)
  end
end
