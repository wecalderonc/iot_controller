module Api
  module V1
    class BatteryLevelsController < ApplicationController
    include ActionController::MimeResponds
    load_and_authorize_resource class: "BatteryLevel"

      def index
        response = BatteryLevels::Execute.new.(index_params)

        if response.success?
          json_response(response.success, :ok)
        else
          json_response({ errors: response.failure[:message] }, :not_found)
        end
      end

      private

      def index_params
        p params
        params.permit(:thing_name).to_h.symbolize_keys
      end
    end
  end
end
