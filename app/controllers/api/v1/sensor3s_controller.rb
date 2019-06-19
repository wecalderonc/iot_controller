module Api
  module V1
    class Sensor3sController < ApplicationController

      def index
        thing = Thing.find_by(id: params[:thing_id])

        if thing.present?
          render json: thing.uplinks.sensor3, status: :ok
        else
          render json: { errors: "Thing doesn't exist" }, status: :not_found
        end
      end
    end
  end
end
