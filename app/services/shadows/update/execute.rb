module Shadows::Update
  _, BaseTx = Common::TxMasterBuilder.new do
    step :validation,            with: Common::Operations::Validator.(:update_state, :shadow)
    step :get_thing,             with: Things::Get.new
    step :get_accumulator,       with: GetAccumulator.new
    step :ready_for_cut,         with: ReadyForCut.new
    map  :build_payload,         with: BuildPayload.new
    step :update,                with: Amazon::Iot::Api::Execute.new
    map  :build_response,        with: BuildResponse.new
  end.Do

  Proxy = {
    restore_supply_with_scheduled_cut: BaseTx.new,
    scheduled_cut:                     BaseTx.new,
    instant_cut:                       BaseTx.new(
      ready_for_cut:   -> input { Dry::Monads::Result::Success.new(input) }
    ),
    restore_supply:                    BaseTx.new(
      get_accumulator: -> input { Dry::Monads::Result::Success.new(input) },
      ready_for_cut:   -> input { Dry::Monads::Result::Success.new(input) }
    )
  }

  Proxy.default = -> input { Dry::Monads::Result::Failure.new(Errors.general_error("The action is not in the list", self.class)) }

  Execute = -> input { Proxy[input[:action_type]].(input) }
end
