module Api
  module V1
    class TimeUplinksController < ApplicationController

      def index
        thing = Thing.find_by(id: params[:thing_id])

        if thing.present?
          render json: thing.uplinks.time_uplink, status: :ok
        else
          render json: { errors: "Thing doesn't exist" }, status: :not_found
        end
      end
    end
  end
end
