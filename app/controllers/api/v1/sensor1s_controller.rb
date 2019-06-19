module Api
  module V1
    class Sensor1sController < ApplicationController

      def index
        guardo = MientrasTanto.aja(params[:thing_id], "sensor1")
        render json: guardo[:result], status: guardo[:status]
      end
    end
  end
end
