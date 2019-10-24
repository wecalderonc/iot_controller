module Api
  module V1
    class BatteryLevelsController < ApplicationController
    include ActionController::MimeResponds
    load_and_authorize_resource class: "BatteryLevel"

      def index
        response = Things::BatteryLevels::Execute.new.(index_params)

        if response.success?
          json_response(response.success, :ok)
        else
          json_response({ errors: response.failure[:message] }, :not_found)
        end
      end

      def otro_index
        response = Things::BatteryLevels::Graphic::Execute.new.(otro_index_params)

        if response.success?
          json_response(response.success, :ok)
        else
          json_response({ errors: response.failure[:message] }, :not_found)
        end
      end

      private

      def index_params
        #TODO: Change this when thing_name -> aws_id
        aws_id = params.permit(:thing_thing_name).to_h.symbolize_keys
        { thing_name: aws_id[:thing_thing_name] }
      end
    end
  end
end
