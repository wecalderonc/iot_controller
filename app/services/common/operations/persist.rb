require 'dry/transaction/operation'

class Common::Operations::Persist
  include Dry::Transaction::Operation
  include Common::Container::Import["object_type"]

  def call(input)
    object = find_or_create_object(object_type, input[:uniq_param])
    params = input[object_type]

    if object.update(params)
      Success object
    else
      Failure Errors.model_error(object.errors.messages, self.class, extra: { params: params, code: 400 })
    end
  end

  private

  def find_or_create_object(object_name, uniq_param)
    object = Utils.to_constant(object_name)
    object.find_or_create_by(**uniq_param)
  end
end
