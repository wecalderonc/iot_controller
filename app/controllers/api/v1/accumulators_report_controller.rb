module Api
  module V1
    class AccumulatorsReportController < ApplicationController

      def index
        index_handler({
          params: params,
          model: :accumulator,
          thing: Thing,
          content_type: get_content_type,
          action: :index
        })
      end

      def show
        get_report({
          params: show_params,
          model: :accumulator,
          content_type: get_content_type,
          action: :show
        })
      end

      private

      def show_params
        params.permit(:thing_name).to_h.symbolize_keys
      end
    end
  end
end
