module Helpers
  module LastMessagesSpecHelper
    def last_messages_fields
      [
        'accumulator',
        'alarm',
        'batteryLevel',
        'valvePosition',
        'sensor1',
        'sensor2',
        'sensor3',
        'sensor4',
        'uplinkBDownlink',
        'timeUplink'
      ]
    end

    def last_messages_properties
      {
        accumulator: { type: :object },
        alarm: { type: :object },
        batteryLevel: { type: :object },
        valvePosition: { type: :object },
        sensor1: { type: :object },
        sensor2: { type: :object },
        sensor3: { type: :object },
        sensor4: { type: :object },
        uplinkBDownlink: { type: :object },
        timeUplink: { type: :object }
      }
    end
  end
end
