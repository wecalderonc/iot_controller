module Locations
  _, CountryStateCity = Common::TxMasterBuilder.new do
    step :get_country, with: Locations::AssignCountry.new
    step :get_state,   with: Locations::AssignState.new
    step :get_city,    with: Locations::AssignCity.new
  end.Do
end
