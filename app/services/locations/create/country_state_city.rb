module Locations::Create
  _, CountryStateCity = Common::TxMasterBuilder.new do
    step :get_country, with: Locations::Create::AssignCountry.new
    step :get_state,   with: Locations::Create::AssignState.new
    step :get_city,    with: Locations::Create::AssignCity.new
  end.Do
end
