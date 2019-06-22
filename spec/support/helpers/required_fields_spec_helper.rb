module Helpers
  module RequiredFieldsSpecHelper
    def thing_fields
      [
        'id',
        'name',
        'status',
        'pac',
        'company_id',
        'created_at',
        'updated_at',
        'last_uplink',
        'last_messages'
      ]
    end

    def uplink_fields
      [
        'id',
        'data',
        'avgsnr',
        'rssi',
        'long',
        'lat',
        'snr',
        'station',
        'seqnumber',
        'time',
        'sec_uplinks',
        'sec_downlinks',
        'created_at',
        'updated_at'
      ]
    end

    def messages_fields
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
  end
end
