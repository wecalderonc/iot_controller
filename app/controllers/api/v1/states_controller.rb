module Api
  module V1
    class StatesController < ApplicationController

      skip_before_action :authorize_request

      def index
        index_response_handler(:states, index_params)
      end

      private

      def index_params
        params.permit(:country_code).to_h.symbolize_keys
      end
    end
  end
end
