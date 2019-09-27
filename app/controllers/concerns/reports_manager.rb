# this concern build manage report response
module ReportsManager

  ReportClass = -> model do
    "Things::#{model.to_s.camelize}sReport".constantize
  end

  QueryMethod = -> model do
    "sort_#{model.downcase}s".to_sym
  end

  def index_handler(input)
    options = {
      last_accumulators: -> { render_last_accumulators(input[:params][:thing_name]) }
    }
    options.default = -> {
      get_report(input)
    }

    options[input[:params][:query]&.to_sym].()
  end

  def get_report(input)
    if input[:content_type] == "text/csv"
      csv_report_response(input.merge(option: :csv_format))
    else
      csv_report_response(input.merge(option: :json_format))
    end
  end

  private

  def build_response(collection, model)
    if collection.present?
      data = ReportClass.(model).(collection)

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

  def render_last_accumulators(thing_name)
    thing = Thing.find_by(name: thing_name)

    if thing.present?
      render json: thing.last_accumulators(10).compact, each_serializer: AccumulatorSerializer
    else
      json_response({ errors: "Device not found" }, :not_found)
    end
  end
end
