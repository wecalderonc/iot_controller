module Api
  module V1
    class CitiesController < ApplicationController

      skip_before_action :authorize_request

      def index
        index_response_handler(:cities, index_params)
      end

      private

      def index_params
        params.permit(:state_code).to_h.symbolize_keys
      end
    end
  end
end
