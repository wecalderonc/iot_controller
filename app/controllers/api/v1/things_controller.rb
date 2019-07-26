module Api
  module V1
    class ThingsController < ApplicationController
      load_and_authorize_resource class: "Thing"

      def index
        @things =  Thing.accessible_by(current_ability)

        render json: @things, status: :ok, each_serializer: ThingsSerializer
      end

      def show
        @thing = Thing.find_by(id: params[:id])

        if @thing.present?
          json_response(@thing)
        else
          json_response({ errors: "thing not found" }, :not_found)
        end
      end

      def update
        p "1. THINGS CONTROLLER UPDATE *****************"
        p create_params
        p response = Things::Update::Execute.(create_params)
        p "1. THINGS CONTROLLER UPDATE ***************** finaliza"
        json_response(response, :ok)
        # @thing = Thing.find_by(id: params[:id])
        # if @thing.present?
        #   json_response(@thing)
        # else
        #   json_response({ errors: "thing not found" }, :not_found)
        # end
      end

      private

      def create_params
        params.permit(:name, :status, :pac, :company_id, :id, :thing_name).to_h.symbolize_keys
      end
    end
  end
end
