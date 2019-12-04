module Inputs
  UserInput = GraphQL::InputObjectType.define do
    name 'UserInput'
    description 'An input object representing arguments for a user'

    argument :id,          types.ID
    argument :first_name,  types.String
    argument :last_name,   types.String
    argument :email,       types.String
    argument :phone,       types.String
    argument :gender,      types.String
    argument :id_number,   types.String
    argument :user_type,   types.String
  end
end
