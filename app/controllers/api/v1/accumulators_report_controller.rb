module Api
  module V1
    class AccumulatorsReportController < ApplicationController

      def index
        accumulators = ThingsQuery.new.sort_accumulators

        build_response(accumulators, :accumulators)
      end

      def show
        show_handler({ params: params, model: :accumulators })
      end
    end
  end
end
