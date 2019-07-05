# this concern build manage report response
module ReportsManager

  ReportClass = -> model do
    "Things::#{model.to_s.camelize}sReport".constantize
  end

  QueryMethod = -> model do
    "sort_#{model.downcase}s".to_sym
  end

  def index_handler(input)
    query_result = build_query(input)
    build_response(query_result, input[:model])
  end

  def show_handler(input)
    thing = Thing.find_by(id: params[:id])

    if thing.present?
      options = {
        last_accumulators: -> { render_last_accumulators(thing) }
      }
      options.default = -> {
        query_result = build_query(input, thing)
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

  def build_query(input, thing = Thing)
    params, model = input.values_at(:params, :model)

    if params[:date].present?
      ThingsQuery.new(thing)
      .date_uplinks_filter(params[:date], model)
    else
      ThingsQuery.new(thing).send(QueryMethod.(model))
    end
  end

  def render_last_accumulators(thing)
    render json: thing.last_accumulators(10).compact, each_serializer: AccumulatorSerializer
  end
end
