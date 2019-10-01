require 'dry/transaction/operation'

class Reports::GetObjects
  include Dry::Transaction::Operation

  def call(input)
    params, model, thing = input.values_at(:params, :model, :thing)

    if params[:date].present?
      objects = ThingsQuery.new(thing)
      .date_uplinks_filter(params[:date], model)
    else
      objects = ThingsQuery.new(thing).send(query_method(model))
    end

    build_response(objects)
  end

  private

  def query_method(model)
    "sort_#{model.downcase}s".to_sym
  end

  def build_response(objects)
    if objects.present?
      Success objects
    else
      Failure Errors.service_error("Results not found", 10104, self.class)
    end
  end
end
