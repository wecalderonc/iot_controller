class ThingsSerializer < ActiveModel::Serializer
    attributes  :id,
                :name,
                :status,
                :pac,
                :company_id,
                :coordinates,
                :created_at,
                :updated_at
end
