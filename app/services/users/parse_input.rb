require 'dry/transaction/operation'

class Users::ParseInput
  include Dry::Transaction::Operation

  def call(input)
    input.tap do |field|
      field[:admin] = is_true?(field[:admin])
    end
  end

  private

  def is_true?(obj)
    obj.to_s.downcase.eql?("true")
  end
end
