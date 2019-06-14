module Common::Operations
  Validator = -> action_type, object_type {
    Common::Operations::Validate.new(validator: Validators::Dependencies[action_type][object_type])
  }
end
