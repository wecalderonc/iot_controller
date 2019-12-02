module Locations::Update
  ParseInput = -> input do
    input.merge(thing_name: input[:new_thing_name])
  end

  AddKeyLocation = -> input do
    input.merge(location: input[:thing].locates)
  end
  _, AssignThing = Common::TxMasterBuilder.new do
    map  :parse_input,       with: ParseInput
    map  :add_key_location,  with: AddKeyLocation
    step :get_thing,         with: Things::Get.new
    step :validate_user,     with: Locations::ValidateUser.new
    step :validate_location, with: Things::ValidateLocation.new
    tee  :assign_thing,      with: Locations::CreateRelations.new
  end.Do
end
