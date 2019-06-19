module Api
  module V1
    class Sensor4sController < ApplicationController

      def index
        guardo = MientrasTanto.aja(params[:thing_id], "sensor4")
        render json: guardo[:result], status: guardo[:status]
      end
    end
  end
end
