module Api
  module V1
    class TimeUplinksController < ApplicationController

      def index
        guardo = MientrasTanto.aja(params[:thing_id], "timeUplink")
        render json: guardo[:result], status: guardo[:status]
      end
    end
  end
end
