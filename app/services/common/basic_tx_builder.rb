module Common
  BasicTxBuilder = -> action_type, object_type do
    Class.new do
      container = Common::BasicTxContainer.(action_type, object_type)

      include Dry::Transaction(container: container)

      step :validate,     with: "ops.validate_input"
      map  :build_params, with: "ops.build_params"
      step :persist,      with: "ops.persist"
    end
  end
end
