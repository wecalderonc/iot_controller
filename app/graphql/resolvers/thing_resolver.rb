module Resolvers
  class ThingResolver < GraphQL::Schema::Resolver
    type Types::ThingType, null: true

    argument :thingInput, Inputs::ThingInput, 'the thing attributes', required: false

    def resolve(input)
      args = input[:thing_input].to_h
      Thing.find_by(args)
    end
  end
end
