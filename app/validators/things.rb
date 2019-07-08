module Validators::Things
  UpdateShadowSchema = Dry::Validation.Schema do
    required(:thing_name).filled(type?: String)
    optional(:value).value(:str?)
    optional(:input_method).filled(type?: Symbol)

    required(:action).filled(type?: Symbol, included_in?: Thing::VALID_ACTIONS)
      .when(eql?: :scheduled_cut)  { value(:value).filled? && value(:input_method).filled? }
  end
end
