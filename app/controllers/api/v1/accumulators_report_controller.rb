module Api
  module V1
    class AccumulatorsReportController < ApplicationController

      def index
        accumulators = ThingsQuery.new.sort_accumulators

        build_response(accumulators, :Accumulators)
      end

      def show
        show_handler({ params: params, model: :Accumulators })
      end
    end
  end
end
