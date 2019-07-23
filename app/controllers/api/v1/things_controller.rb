module Api
  module V1
    class ThingsController < ApplicationController
      load_and_authorize_resource class: "Thing"
      relations = [:owns, :operates, :sees]

      def index
        user =  current_user.success
        #@things = Thing.all

        @things = []
        @things << Thing.find_by(owner: user)
        @things << Thing.find_by(viewer: user)
        @things << Thing.find_by(operator: user)
        p "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        p @things.compact
        p "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

        render json: @things.compact, status: :ok, each_serializer: ThingsSerializer
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
