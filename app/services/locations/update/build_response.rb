require 'dry/transaction'

class Locations::Update::BuildResponse
  include Dry::Transaction

  def call(input)
    input[:location]
  end
end
