class LocationDashboardSerializer < ActiveModel::Serializer
  attributes  :name

  has_one :thing, serializer: ThingDashboardSerializer
end
