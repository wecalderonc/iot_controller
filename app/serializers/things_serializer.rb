class ThingsSerializer < ActiveModel::Serializer
  attributes  :id,
              :name,
              :status,
              :pac,
              :company_id,
              :units,
              :latitude,
              :longitude,
              :created_at,
              :updated_at
end
