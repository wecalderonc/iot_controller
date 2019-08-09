module Validators::Alarms
  UpdateSchema = Dry::Validation.Schema do
    required(:alarm_id).filled?(type?: String)
    required(:params).schema do
      required(:viewed).filled(type?: TrueClass)
    end
  end
end
