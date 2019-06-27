module Api
  module V1
    class AlarmsReportController < ApplicationController
    include ActionController::MimeResponds

      def index
        alarms = ThingsQuery.new.sort_alarms

        build_response(alarms, "Alarms")
      end

      def show
        show_handler({ params: params, model: "Alarms" })
=begin
        thing = Thing.find_by(id: params[:id])

        if thing.present?
          alarms = ThingsQuery.new(thing).sort_alarms
          build_response(alarms)
        else
          json_response({ errors: "Device not found" }, :not_found)
        end
=end
      end

    end
  end
end
