class ThingsSerializer < ActiveModel::Serializer
    attributes  :id,
                :name,
                :status,
                :pac,
                :company_id,
                :latitude,
                :longitude,
                :created_at,
                :updated_at
end
