module Common
  BasicTxContainer = -> action_type, object_type, container: Common::Container do
    Class.new(container) do
      namespace("ops") do
        register "validate_input", Common::Operations::Validate.new(validator: Validators::Dependencies[action_type][object_type])
        register "build_params",   Common::Operations::BuildParams.new(object_type: object_type)
        register "persist",        Common::Operations::Persist.new(object_type: object_type)
      end
    end
  end
end
