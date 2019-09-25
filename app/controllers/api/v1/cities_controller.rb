module Api
  module V1
    class CitiesController < ApplicationController

      skip_before_action :authorize_request

      def index
        cities = Cities::Index::Execute.new.(index_params)

        if cities.success?
          render json: cities.success, status: :ok, each_serializer: CitySerializer
        else
          message, code = cities.failure.values_at(:message, :code)

          json_response({ errors: message, code: code}, :not_found)
        end

      end

      private

      def index_params
        params.permit(:state_code).to_h.symbolize_keys
      end
    end
  end
end
