module Api
  module V1
    class LocationsController < ApplicationController

      START_DATE = [:start_day, :start_month, :start_year]
      COUNTRY_STATE_CITY = [:country, :state, :city]

      def create
        create_response = Locations::Create::Execute.new.(create_location)

        if create_response.success?
          json_response(create_response.success)
        else
          json_response({ errors: create_response.failure[:message] }, :not_found)
        end
      end

      private

      def create_location
        params.permit(
          :thing_name,
          location: (
            Location::REQUIRED_FIELDS << [:latitude, :longitude]
          ),
          country_state_city: (
            COUNTRY_STATE_CITY
          ),
          schedule_billing: (
            ScheduleBilling::REQUIRED_FIELDS << START_DATE
          ),
          schedule_report: (
            ScheduleReport::REQUIRED_FIELDS << START_DATE
          )
        ).to_h.deep_symbolize_keys
      end
    end
  end
end
