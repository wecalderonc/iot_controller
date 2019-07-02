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
        last_accumulators: -> { last_accumulators(thing) }
      }
      options.default = -> {
        query_result = ThingsQuery.new(thing).send(QueryMethod.(input[:model]))
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

  def last_accumulators(thing)
    json_response(thing.uplinks.accumulator.limit(10))
  end
end
