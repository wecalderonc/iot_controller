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
    object.city.state.code_iso
  end

  def country
    object.city.state.country.code_iso
  end
end
