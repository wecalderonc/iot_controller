module Api
  module V1
    class AccumulatorsReportController < ApplicationController

      def index
        index_handler({ params: params, model: :accumulator })
      end

      def show
        show_handler({ params: params, model: :accumulator })
      end
    end
  end
end
