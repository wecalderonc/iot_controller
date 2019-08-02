require 'dry/transaction/operation'

class Users::ParseInput
  include Dry::Transaction::Operation

  def call(input)
    p input
    input.tap do |field|
      field[:gender] = field[:gender].to_sym
      field[:id_type] = field[:id_type].to_sym
    end
  end
end
