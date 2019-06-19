module Api
  module V1
    class BatteryLevelsController < ApplicationController

      def index
        guardo = MientrasTanto.aja(params[:thing_id], "batteryLevel")
        render json: guardo[:result], status: guardo[:status]
      end
    end
  end
end
