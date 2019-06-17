module Api
  module V1
    class UplinksController < ApplicationController
      def index
        last_uplink = Uplink.order(:created_at).last

        if last_uplink.present?
          render json: last_uplink, status: :ok
        else
          render json: { errors: "There aren't any Uplinks" }, status: :not_found
        end
      end
    end
  end
end
