require 'dry/transaction/operation'

class Amazon::Iot::Api::InitializeClient
  include Dry::Transaction::Operation

  def call(input)
    client = Aws::IoTDataPlane::Client.new(
      region: 'us-east-1',
      access_key_id: ENV['access_key'],
      secret_access_key: ENV['secret_key'],
      endpoint: ENV['endpoint']
      )
    input.merge(client: client)
  end
end
