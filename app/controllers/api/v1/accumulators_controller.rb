module Api
  module V1
    class AccumulatorsController < ApplicationController

      def index
        p params
        response = MientrasTanto.aja(params[:thing_id], "accumulator")
        render json: response[:result], status: response[:status]
      end
    end
  end
end
