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
          render json: { errors: "Device not found" }, status: :not_found
        end
      end

      private

      def build_response(alarms)
        if alarms.present?
          data =  Things::AlarmsReport.(alarms)

          respond_to do |format|
            format.all { send_data data, filename: "device-alarms-#{Date.today}.csv" }
          end
        else
          render json: { errors: "No results found" }, status: :not_found
        end
      end
    end
  end
end
