module Api
  module V1
    class AlarmsController < ApplicationController
    include ActionController::MimeResponds

      def update
        alarm_service = Alarms::Update::Execute.new.(update_params)

        if alarm_service.success?
          json_response(alarm_service.success, :ok)
        else
          json_response(alarm_service.failure, :not_found)
        end
      end

      private

      def update_params
        alarm_id = params.require(:id)
        { alarm_id: alarm_id, params: { viewed: true } }
      end
    end
  end
end
