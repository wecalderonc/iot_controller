module Api
  module V1
    class LocationsController < ApplicationController

      def create
        create_response = Locations::Create::Execute.new.(create_location_params)

        if create_response.success?
          json_response(create_response.success)
        else
          json_response({ errors: create_response.failure[:message] }, :not_found)
        end
      end
    end
  end
end
