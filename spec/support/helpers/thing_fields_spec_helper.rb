module Helpers
  module ThingFieldsSpecHelper
    def thing_fields_required
      [
        'id',
        'name',
        'status',
        'pac',
        'company_id',
        'units',
        'latitude',
        'longitude',
        'created_at',
        'updated_at',
        'last_uplink',
        'last_messages'
      ]
    end

    def thing_properties
      {
        id: { type: :string },
        name: { type: :string },
        status: { type: :string },
        pac: { type: :string },
        company_id: { type: :string },
        units: { type: :object },
        latitude: { type: :float },
        longitude: { type: :float },
        created_at: { type: :string },
        updated_at: { type: :string },
        last_uplink: {
          required: last_uplink_fields,
          properties: last_uplink_properties
        },
        last_messages: {
          required: last_messages_fields,
          properties: last_messages_properties
        }
      }
    end

    def things_properties
      {
        id: { type: :string },
        name: { type: :string },
        status: { type: :string },
        pac: { type: :string },
        company_id: { type: :string },
        latitude: { type: :float },
        longitude: { type: :float },
        created_at: { type: :string },
        updated_at: { type: :string }
      }
    end

    def things_fields_required
      [
        'id',
        'name',
        'status',
        'pac',
        'company_id',
        'latitude',
        'longitude',
        'created_at',
        'updated_at'
      ]
    end
  end
end
