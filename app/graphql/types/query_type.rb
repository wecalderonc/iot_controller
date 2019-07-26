module Types
  class QueryType < GraphQL::Schema::Object
    description "The query root of this schema"

    field :things,
      resolver: Resolvers::ThingsResolver,
      description: 'Find things by multiple params'

    field :thing,
      resolver: Resolvers::ThingResolver,
      description: 'Find thing by multiple params'

    field :user,
      resolver: Resolvers::UserResolver,
      description: 'Find user by multiple params'
  end
end
