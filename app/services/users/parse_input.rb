require 'dry/transaction/operation'

class Users::ParseInput
  include Dry::Transaction::Operation

  def call(input)
    input.tap do |field|
      field[:gender] = field[:gender].to_sym
      field[:id_type] = field[:id_type].to_sym
      field[:admin] = is_true?(field[:admin])
      field[:user_type] = field[:user_type].to_sym
    end
  end

  private

  def is_true?(obj)
    obj.to_s.downcase.eql?("true")
  end
end
