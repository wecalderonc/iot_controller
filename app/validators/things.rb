module Validators::Things
  UpdateShadowSchema = Dry::Validation.Schema do
  #validar que thing exista
    required(:thing_name).filled(type?: String)
    required(:type).filled(type?: Symbol)
    required(:action).filled(type?: Symbol)
  end
end
