module Users::Locations::Index
  _, Execute = Common::TxMasterBuilder.new do
    step :validation,             with: Common::Operations::Validator.(:get, :locations)
    step :get_user,               with: Users::Get.new
    step :get_locations,          with: Users::Locations::Index::Get.new
  end.Do
end
