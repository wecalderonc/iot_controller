class LocationSerializer < ActiveModel::Serializer
  has_one :schedule_billing
  has_one :schedule_report
  has_one :city

  attributes  :name,
              :address,
              :latitude,
              :longitude,
              :state,
              :country

  def state
    state = object.city.state
    { name: state.name, code_iso: state.code_iso }
  end

  def country
    country = object.city.state.country
    { name: country.name, code_iso: country.code_iso }
  end
end
