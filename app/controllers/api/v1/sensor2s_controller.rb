module Api
  module V1
    class Sensor2sController < ApplicationController

      def index
       guardo = MientrasTanto.aja(params[:thing_id], "sensor2")
        render json: guardo[:result], status: guardo[:status]
      end
    end
  end
end
