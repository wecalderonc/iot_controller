module Validators::Things
  UpdateShadowSchema = Dry::Validation.Schema do
    required(:thing_name).filled(type?: String)
    required(:type).filled(type?: Symbol, included_in?: Thing::VALID_UPDATE_TYPES)
    required(:action).filled(type?: Symbol, included_in?: Thing::VALID_ACTIONS)
  end
end
