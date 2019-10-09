module Api
  module V1
    class LocationsController < ApplicationController

      START_DATE = [:start_day, :start_month, :start_year]
      COUNTRY_STATE_CITY = [:country, :state, :city]

      def index
        locations = Users::Locations::Index::Execute.new.(index_params)

        if locations.success?
          render json: locations, status: :ok, each_serializer: LocationDashboardSerializer
        else
          json_response(locations.failure, :not_found)
        end
      end

      def show
        show_response = Locations::Execute.new.(show_params)
        if show_response.success?
          json_response(show_response.success)
        else
          json_response({ errors: show_response.failure[:message] }, :not_found)
        end
      end

      def create
        create_response = Locations::Create::Execute.new.(create_params)

        if create_response.success?
          json_response(create_response.success)
        else
          json_response({ errors: create_response.failure[:message] }, :not_found)
        end
      end

      def update
        update_response = Locations::Update::Execute.new.(update_params)

        if update_response.success?
          json_response(update_response.success)
        else
          json_response({ errors: update_response.failure[:message] }, :not_found)
        end
      end

      private

      def index_params
        email = params.permit(:user_email).to_h.symbolize_keys
        { email: email[:user_email] }
      end

      def show_params
        #TODO: Change this when thing_name -> aws_id·
        aws_id = params.permit(:thing_name).to_h.symbolize_keys
        { thing_name: aws_id[:thing_name] }
      end

      def update_params
        params.permit(:new_thing_name).to_h.symbolize_keys
        .merge(create_params)
      end

      def create_params
        params.permit(
          :thing_name,
          :email,
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
