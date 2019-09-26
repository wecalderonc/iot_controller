module Api
  module V1
    class AlarmsReportController < ApplicationController
    include ActionController::MimeResponds

      def index
        content_type = request.headers["CONTENT_TYPE"]
        index_handler({ params: params, model: :alarm, thing: Thing }, content_type)
      end

      def show
        show_handler({ params: params, model: :alarm })
      end
    end
  end
end
