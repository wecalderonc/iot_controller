module Helpers
  module AccumulatorSpecHelper
    def accumulator_fields
      Accumulator.attributes.keys
    end

    def accumulator_properties
      {
        id: { type: :string},
        value: { type: :string},
        created_at: { type: :string },
        updated_at: { type: :string }
      }
    end
  end
end
