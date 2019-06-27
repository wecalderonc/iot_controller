module Api
  module V1
    class ThingsController < ApplicationController
      def show
        thing = Thing.find_by(id: params[:id])
        render json: thing, status: :ok
      end
    end
  end
end
