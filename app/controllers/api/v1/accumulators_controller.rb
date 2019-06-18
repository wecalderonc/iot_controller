module Api
  module V1
    class AccumulatorsController < ApplicationController

      def index
        thing = Thing.find(params[:thing_id])
        render json: thing.uplinks.accumulator, status: :ok
      end
    end
  end
end
