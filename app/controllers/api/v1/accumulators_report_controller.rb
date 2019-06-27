module Api
  module V1
    class AccumulatorsReportController < ApplicationController

      def index
        accumulators = ThingsQuery.new.sort_accumulators

        build_response(accumulators)
      end

      def show
        thing = Thing.find_by(id: params[:id])

        if thing.present?
          accumulators = ThingsQuery.new(thing).sort_accumulators
          build_response(accumulators)
        else
          json_response({ errors: "Device not found" }, :not_found)
        end
      end

      private

      def build_response(accumulators)
        if accumulators.present?
          data =  Things::AccumulatorsReport.(accumulators)

          csv_response(data, "device-accumulators")
        else
          json_response({ errors: "No results found" }, :not_found)
        end
      end
    end
  end
end
