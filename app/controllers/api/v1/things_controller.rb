module Api
  module V1
    class ThingsController < ApplicationController
      load_and_authorize_resource class: "Thing"

      def index
        @things = Thing.all
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
