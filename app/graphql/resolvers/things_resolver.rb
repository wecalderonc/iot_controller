module Resolvers
  class ThingsResolver < GraphQL::Schema::Resolver
    type [Types::ThingType], null: false

    argument :thingInput, Inputs::ThingInput, 'the thing attributes', required: false

    def resolve(input)
      args = input[:thing_input].to_h
      Thing.where(args)
    end
  end
end
