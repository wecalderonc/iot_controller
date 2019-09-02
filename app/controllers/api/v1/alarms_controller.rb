module Api
  module V1
    class AlarmsController < ApplicationController
    include ActionController::MimeResponds
    load_and_authorize_resource class: "Alarm"

      def index
        thing_alarms = Things::Alarms::Index::Execute.new.(index_params)

        if thing_alarms.success?
          authorized_alarms = authorize(thing_alarms)
          json_response(authorized_alarms, :ok)
        else
          json_response(thing_alarms.failure, :not_found)
        end
      end

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

      def index_params
        #TODO: Change this when thing_name -> aws_id·
        aws_id = params.permit(:thing_thing_name).to_h.symbolize_keys
        { thing_name: aws_id[:thing_thing_name] }
      end
    end
  end
end
