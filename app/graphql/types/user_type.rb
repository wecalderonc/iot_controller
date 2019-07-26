module Types
  class UserType < Types::BaseObject
    graphql_name "User"
    description "An user"

    field :id, ID, null: false
    field :first_name, String, null: false
    field :last_name, String, null: false
    field :email, String, null: false
    field :phone, String, null: false
    field :gender, String, null: false
    field :id_number, String, null: false
    field :code_number, String, null: false
    field :user_type, String, null: false
    field :things, [Types::ThingType], null: false

    def things
      object.owns + object.operates + object.sees
    end
  end
end
