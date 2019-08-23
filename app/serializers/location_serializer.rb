class LocationSerializer < ActiveModel::Serializer
  has_one :schedule_billing
  has_one :schedule_report
  has_one :city

  attributes  :name,
              :address,
              :latitude,
              :longitude
end
