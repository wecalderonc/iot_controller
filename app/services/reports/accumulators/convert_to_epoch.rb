require 'dry/transaction/operation'

class Reports::Accumulators::ConvertToEpoch
  include Dry::Transaction::Operation

  def call(period)
    dates = period[:date]

    dates.each do |type, date|
      dates[type] = date.to_time.to_i.to_s
    end
  end
end
