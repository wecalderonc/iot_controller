class CitySerializer < ActiveModel::Serializer
  has_one :state

  attributes  :name
end
