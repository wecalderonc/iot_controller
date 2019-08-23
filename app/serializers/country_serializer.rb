class CountrySerializer < ActiveModel::Serializer
  attributes  :name,
              :code_iso
end
