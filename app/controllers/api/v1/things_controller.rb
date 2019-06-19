module Api
  module V1
    class ThingsController < ApplicationController

      def index
        response = MientrasTanto.aja(params[:thing_id], params[:message_name].chop)
        render json: response[:result], status: response[:status]
      end

      def show
        thing = Thing.find(params[:id])
        render json: thing, status: :ok
      end
    end
  end
end




