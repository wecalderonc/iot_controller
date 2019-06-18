class AccumulatorSerializer < ActiveModel::Serializer
  attributes :id, :value, :created_at, :updated_at
end
