module Types
  class ThingType < Types::BaseObject
    field :id, ID, null: false
    field :status, String, null: false
    field :pac, String, null: false
    field :companyId, String, null: false
    field :coordinates, [Float], null: false
    field :user, [Types::UserType], null: false
  end
end
