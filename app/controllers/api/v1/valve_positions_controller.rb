module Api
  module V1
    class ValvePositionsController < ApplicationController

      def index
        guardo = MientrasTanto.aja(params[:thing_id], "valvePosition")
        render json: guardo[:result], status: guardo[:status]
      end
    end
  end
end
