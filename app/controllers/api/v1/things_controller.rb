module Api
  module V1
    class ThingsController < ApplicationController
      load_and_authorize_resource

      def index
        @things = Thing.accessible_by(current_ability)

        render json: @things, status: :ok, each_serializer: ThingsSerializer
      end

      def show
        @thing = Thing.find_by(name: params[:thing_name])

        if @thing.present?
          authorize! :read, @thing
          json_response(@thing)
        else
          json_response({ errors: "thing not found" }, :not_found)
        end
      end

      def update
        update_response = Things::Update::Execute.new.(create_params)

        if update_response.success?

          json_response(authorize! :update, update_response.success, :ok)
        else
          json_response({ errors: update_response.failure[:message] }, :not_found)
        end
      end

      private

      def create_params
        params.permit(:thing_name, :pac, :company_id, :latitude, :longitude, :name, :status).to_h.symbolize_keys
      end
    end
  end
end
