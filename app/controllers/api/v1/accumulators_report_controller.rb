module Api
  module V1
    class AccumulatorsReportController < ApplicationController
    include ActionController::MimeResponds

      def index
        accumulators = ThingsQuery.new.sort_accumulators

        build_response(accumulators)
      end

      def show
        thing = Thing.find_by(id: params[:id])

        if thing.present?
          accumulators = ThingsQuery.new.sort_accumulators(thing)
          build_response(accumulators)
        else
          render json: { errors: "Device not found" }, status: :not_found
        end
      end

      private

      def build_response(accumulators)
        if accumulators.present?
          data =  Things::AccumulatorsReport.(accumulators)

          respond_to do |format|
            format.all { send_data data, filename: "device-accumulators-#{Date.today}.csv" }
          end
        else
          render json: { errors: "No results found" }, status: :not_found
        end
      end
    end
  end
end
