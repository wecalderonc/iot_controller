module Api
  module V1
    class UplinkBDownlinksController < ApplicationController

      def index
        guardo = MientrasTanto.aja(params[:thing_id], "uplinkBDownlink")
        render json: guardo[:result], status: guardo[:status]
      end
    end
  end
end
