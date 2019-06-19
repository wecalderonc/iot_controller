module Api
  module V1
    class Sensor3sController < ApplicationController

      def index
        guardo = MientrasTanto.aja(params[:thing_id], "sensor3")
        render json: guardo[:result], status: guardo[:status]
      end
    end
  end
end
