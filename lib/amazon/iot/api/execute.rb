module Amazon::Iot::Api
  _, Execute = Common::TxMasterBuilder.new do

    Errors = -> { [
      ArgumentError,
      Aws::Errors::DynamicErrors,
      Aws::IoTDataPlane::Errors::ServiceError,
      Aws::Errors::MissingCredentialsError,
      Seahorse::Client::NetworkingError
    ] }

    step :validate_input,                    with: Amazon::Iot::Api::ValidateInput.new
    map  :initialize_client,                 with: Amazon::Iot::Api::InitializeClient.new
    try  :request_data, catch: Errors.(),    with: Amazon::Iot::Api::RequestData.new
    map  :parse_data,                        with: Amazon::Iot::Api::ParseData.new
  end.Do
end
