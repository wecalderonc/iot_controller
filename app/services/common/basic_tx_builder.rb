module Common
  BasicTxBuilder = -> action_type, object_type do
    Common::TxMasterBuilder.new do
      step :validation,         with: Common::Operations::Validator.(action_type, object_type)
      map  :build_params,       with: Common::Operations::BuildParams.new(object_type: object_type)
      step :persist,            with: Common::Operations::Persist.new(object_type: object_type)
    end.Do
  end
end
