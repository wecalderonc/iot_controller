module Types
  class ThingType < Types::BaseObject
    graphql_name "Thing"
    description "A device"

    field :id, ID, null: false
    field :name, String, null: false
    field :status, String, null: false
    field :pac, String, null: false
    field :companyId, String, null: false
    field :coordinates, [Float], null: false
  end
end
