module Validators::Shadows
  UpdateShadowSchema = Dry::Validation.Schema do
    required(:thing_name).filled(type?: String)
    optional(:value).value(:str?)
    optional(:input_method).filled(type?: Symbol, included_in?: Shadow::VALID_INPUT_TYPES)

    required(:action_type).filled(type?: Symbol, included_in?: Shadow::VALID_ACTIONS)
      .when(eql?: :scheduled_cut) { value(:input_method).filled? }
      .when(eql?: :scheduled_cut) { value(:value).filled? }
      .when(eql?: :restore_supply_with_scheduled_cut) { value(:input_method).filled? }
      .when(eql?: :restore_supply_with_scheduled_cut) { value(:value).filled? }
  end
end
