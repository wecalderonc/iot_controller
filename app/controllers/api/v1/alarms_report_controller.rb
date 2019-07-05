module Api
  module V1
    class AlarmsReportController < ApplicationController
    include ActionController::MimeResponds

      def index
        index_handler({ params: params, model: :alarm })
      end

      def show
        show_handler({ params: params, model: :alarm })
      end
    end
  end
end
