module Api
  module V1
    class DownlinksController < ApplicationController
      def create
        downlink = Downlinks::Create::Execute.new.(create_params)

        if downlink.success?
          render json: downlink, status: :ok
        else
          errors = downlink.failure
          render json: { errors: errors[:errors] }, status: errors[:status]
        end
      end

      private

      def create_params
        params.permit(*Downlink::PERMITED_PARAMS)
      end
    end
  end
end
