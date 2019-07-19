module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :thing, [Types::ThingType], null: true
  end
end
