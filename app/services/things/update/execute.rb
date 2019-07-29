module Things::Update
  _, Execute = Common::TxMasterBuilder.new do
    step :validation,            with: Common::Operations::Validator.(:update_thing, :thing)
    step :get_thing,             with: Things::Get.new
    step :update,                with: Things::Update::Update.new
    map  :build_response,        with: Things::Update::BuildResponse.new
  end.Do
end


