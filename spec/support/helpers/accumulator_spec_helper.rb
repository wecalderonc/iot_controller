module Helpers
  module AccumulatorSpecHelper
    def accumulator_fields
      [
        'id',
        'value',
        'created_at',
        'updated_at'
      ]
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
