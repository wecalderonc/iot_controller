module Api
  module V1
    class BatteryLevelsController < ApplicationController
    include ActionController::MimeResponds
    load_and_authorize_resource class: "BatteryLevel"

      def index
        options = {
          graphic: -> { Things::BatteryLevels::Graphic::Execute.new.(index_params) }
        }

        options.default = -> { Things::BatteryLevels::Execute.new.(index_params) }

        response = options[index_params[:subaction]&.to_sym].()

        if response.success?
          json_response(response.success, :ok)
        else
          json_response({ errors: response.failure[:message] }, :not_found)
        end
      end

      private

      def index_params
        #TODO: Change this when thing_name -> aws_id
        aws_id = params.permit(:thing_thing_name, :subaction).to_h.symbolize_keys
        { thing_name: aws_id[:thing_thing_name], subaction: aws_id[:subaction] }
      end
    end
  end
end
