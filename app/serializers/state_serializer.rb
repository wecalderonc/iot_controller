class StateSerializer < ActiveModel::Serializer
  has_one :country

  attributes  :name,
              :code_iso
end
