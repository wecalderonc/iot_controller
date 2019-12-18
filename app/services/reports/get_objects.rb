require 'dry/transaction/operation'

class Reports::GetObjects
  include Dry::Transaction::Operation
  include ModelModifiers

  def call(input)
    params, model, thing = input.values_at(:params, :model, :thing)

    if params[:date].present?
      objects = ThingsQuery.new(thing)
      .date_uplinks_filter(params[:date], model)
    else
      objects = ThingsQuery.new(thing).send(query_method(model))
    end

    if model == :accumulator
      delete_objects_with_property!(objects, "wrong_consumption")
    end

    build_response(input, objects)
  end

  private

  def query_method(model)
    "sort_#{model.downcase}s".to_sym
  end

  def build_response(input, objects)
    if objects.present?
      Success input.merge(objects: objects)
    else
      Failure Errors.service_error("Results not found", 10104, self.class)
    end
  end
end
