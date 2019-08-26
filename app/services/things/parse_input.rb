require 'dry/transaction/operation'

class Things::ParseInput
  include Dry::Transaction::Operation

  def call(input)
    input.tap do |field|
      field[:company_id] = field[:company_id].to_i
      field[:latitude] = field[:latitude].to_f
      field[:longitude] = field[:longitude].to_f
    end
  end
end
