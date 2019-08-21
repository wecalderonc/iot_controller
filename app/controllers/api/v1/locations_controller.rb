module Api
  module V1
    class LocationsController < ApplicationController

      def create
        create_response = Locations::Create::Execute.new.(create_params)

        if create_response.success?
          json_response(create_response.success)
        else
          json_response({ errors: create_response.failure[:message] }, :not_found)
        end
      end

      private

      def create_params
        params.permit(:id, :thing_name, params: {}).to_h.symbolize_keys
      end
    end
  end
end
