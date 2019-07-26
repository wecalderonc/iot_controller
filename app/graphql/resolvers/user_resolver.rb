module Resolvers
  class UserResolver < GraphQL::Schema::Resolver
    type Types::UserType, null: true

    argument :userInput, Inputs::UserInput, 'the user attributes', required: false

    def resolve(input)
      args = input[:user_input].to_h
      User.find_by(args)
    end
  end
end
