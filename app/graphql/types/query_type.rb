module Types
  class QueryType < GraphQL::Schema::Object
    description "The query root of this schema"

    field :thing, ThingType, null: true do
      description "Find a thing by user name"
      argument :name, String, required: false
      argument :id, String, required: false
    end

    def thing(args)
      puts "*" * 100
      pp Thing.find_by(args)
    end
  end
end
