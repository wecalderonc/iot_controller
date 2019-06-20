module Api
  module V1
    class ThingsController < ApplicationController
      def show
        thing = Thing.find(params[:id])
        render json: thing, status: :ok
      end
    end
  end
end




