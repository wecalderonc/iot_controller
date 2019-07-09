require 'dry/transaction/operation'

class Common::Operations::BuildParams
  include Dry::Transaction::Operation
  include Common::Container::Import["object_type"]

  def call(input)
    object_model = Utils.to_constant(object_type)
    input.merge!(uniq_param: uniq_param(object_model::UniqParam, input[object_type]))

    object = Utils.to_constant("#{object_model}s")
    object::BuildParams.new.(input)
  end

  private

  def uniq_param(uniq_param, params)
    { uniq_param => params[uniq_param] }
  end
end
