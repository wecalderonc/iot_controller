module Inputs
  ThingInput = GraphQL::InputObjectType.define do
    name 'ThingInput'
    description 'An input object representing arguments for a thing'

    argument :id,         types.ID
    argument :name,       types.String
    argument :status,     types.String
    argument :company_id, types.String
    argument :pac,        types.String
    argument :latitude,   types.Float
    argument :longitude,  types.Float
  end
end
