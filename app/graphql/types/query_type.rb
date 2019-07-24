module Types
  class QueryType < GraphQL::Schema::Object
    description "The query root of this schema"

    field :things, [ThingType], null: true do
      description "Find things by multiple params"
      argument :name, String, required: false
      argument :status, String, required: false
      argument :companyId, String, required: false
      argument :pac, String, required: false
      argument :coordinates, [Float], required: false
    end

    def things(args)
      if args.has_key?(:coordinates)
        #TODO querying multiple args + coordinates
        Thing.as(:cosita)
          .where("cosita.coordinates = {coordinates}")
          .params(coordinates: args[:coordinates])
      else
        Thing.where(args)
      end
    end
  end
end
