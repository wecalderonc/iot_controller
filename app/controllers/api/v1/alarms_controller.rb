module Api
  module V1
    class AlarmsController < ApplicationController

      def index
        guardo = MientrasTanto.aja(params[:thing_id], "alarm")
        render json: guardo[:result], status: guardo[:status]
      end
    end
  end
end
