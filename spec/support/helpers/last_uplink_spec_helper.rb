module Helpers
  module LastUplinkSpecHelper
    def last_uplink_fields
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

    def last_uplink_properties
      {
        id: { type: :string},
        data: { type: :string},
        avgsnr: { type: :string},
        rssi: { type: :string},
        long: { type: :string},
        lat: { type: :string},
        snr: { type: :string},
        station: { type: :string},
        seqnumber: { type: :string},
        time: { type: :string},
        sec_uplinks: { type: :string},
        sec_downlinks: { type: :string},
        created_at: { type: :string },
        updated_at: { type: :string }
      }
    end
  end
end
