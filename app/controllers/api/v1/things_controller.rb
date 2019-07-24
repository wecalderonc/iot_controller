module Api
  module V1
    class ThingsController < ApplicationController
      load_and_authorize_resource class: "Thing"
      relations = [:owns, :operates, :sees]

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
    end
  end
end
