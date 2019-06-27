module Api
  module V1
    class AlarmsReportController < ApplicationController
    include ActionController::MimeResponds

      def index
        alarms = ThingsQuery.new.sort_alarms

        build_response(alarms)
      end

      def show
        thing = Thing.find_by(id: params[:id])

        if thing.present?
          alarms = ThingsQuery.new(thing).sort_alarms
          build_response(alarms)
        else
          json_response({ errors: "Device not found" }, :not_found)
        end
      end

      private

      def build_response(alarms)
        if alarms.present?
          data =  Things::AlarmsReport.(alarms)

          csv_response(data, "device-alarms")
        else
          json_response({ errors: "No results found" }, :not_found)
        end
      end
    end
  end
end
