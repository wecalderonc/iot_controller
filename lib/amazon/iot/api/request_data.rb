require 'dry/transaction/operation'

class Amazon::Iot::Api::RequestData
  include Dry::Transaction::Operation

  def call(input)
    request = {
      desired: UpdateThingShadow,
      reported: GetThingShadow
    }[input[:type]].(input)

    input.merge(request: request)
  end

  private

  UpdateThingShadow = -> input do
    desired = { state: { desired: { data: "#{ input[:payload] }" } } }.to_json

    input[:client].update_thing_shadow({
      thing_name: input[:thing_name],
      payload: desired
    })
  end

  GetThingShadow = -> input do
    input[:client].get_thing_shadow({ thing_name: input[:thing_name] })
  end
end
