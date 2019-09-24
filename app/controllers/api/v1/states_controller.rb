module Api
  module V1
    class StatesController < ApplicationController

      skip_before_action :authorize_request

      def index
        states = States::Index::Execute.new.(index_params)

        if states.success?
          render json: states.success, status: :ok, each_serializer: StateSerializer
        else
          message, code = states.failure.values_at(:message, :code)

          json_response({ errors: message, code: code}, :not_found)
        end

      end

      private

      def index_params
        params.permit(:country_code).to_h.symbolize_keys
      end
    end
  end
end
