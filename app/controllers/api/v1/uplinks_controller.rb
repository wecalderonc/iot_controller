module Api
  module V1
    class UplinksController < ApplicationController
      def index
        last_uplink = Uplink.order(:created_at).last
        if last_uplink
          render json: {  id: last_uplink.id,
                          data: last_uplink.data,
                          avgsnr: last_uplink.avgsnr,
                          rssi: last_uplink.rssi,
                          long: last_uplink.long,
                          lat: last_uplink.lat,
                          snr: last_uplink.snr,
                          station: last_uplink.station,
                          seqnumber: last_uplink.seqnumber,
                          time: last_uplink.time,
                          sec_uplinks: last_uplink.sec_uplinks,
                          sec_downlinks: last_uplink.sec_downlinks
                        }, status: :ok
        else
          render json: { errors: "last_uplink not found" }, status: :not_found
        end
      end
    end
  end
end
