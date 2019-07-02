require 'dry/transaction/operation'

class Amazon::Iot::Api::InitializeClient
  include Dry::Transaction::Operation

  def call(input)
    client = Aws::IoTDataPlane::Client.new(
      region: 'us-east-1',
      access_key_id: ENV['ACCESS_KEY'],
      secret_access_key: ENV['SECRET_KEY'],
      endpoint: ENV['AWS_IOT_ENDPOINT']
      )
    input.merge(client: client)
  end
end
