require 'dry/transaction/operation'

class Common::Operations::Validate
  include Dry::Transaction::Operation
  include Common::Container::Import["validator"]

  def call(input)
    result = validator.(input.to_h)

    if result.success?
      Success input.deep_symbolize_keys
    else
      Failure Errors.general_error(result.errors, self.class, extra: { code: 400, params: input.to_h })
    end
  end
end
