class LocationSerializer < ActiveModel::Serializer
  has_one :schedule_billing
  has_one :schedule_report

  attributes  :name,
              :address,
              :latitude,
              :longitude,

              :country,
              :state,
              :city,

  def country
    object.city.state.country.name
  end

  def state
    object.city.state.name
  end

  def city
    object.city.name
  end
end
