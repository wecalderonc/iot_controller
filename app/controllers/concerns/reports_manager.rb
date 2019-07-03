# this concern build manage report response
module ReportsManager

  ReportClass = -> model do
    "Things::#{model.to_s.camelize}Report".constantize
  end

  QueryMethod = -> model do
    "sort_#{model.downcase}".to_sym
  end

  def show_handler(input)
    thing = Thing.find_by(id: input[:params][:id])

    if thing.present?

      options = {
        last_accumulators: -> { json_response(thing.last_accumulators(10)) }
      }
      options.default = -> {
        query_result = build_query(thing, input)
        build_response(query_result, input[:model])
      }

      options[input[:params][:query]&.to_sym].()

    else
      json_response({ errors: "Device not found" }, :not_found)
    end
  end

  private

  def build_response(collection, model)
    if collection.present?
      data =  ReportClass.(model).(collection)

      csv_response(data, "Device-#{model}")
    else
      json_response({ errors: "No results found" }, :not_found)
    end
  end

  def build_query(thing, input)
    ThingsQuery.new(thing).send(QueryMethod.(input[:model]))
  end
end
