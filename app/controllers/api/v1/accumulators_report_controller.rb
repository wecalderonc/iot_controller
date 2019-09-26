module Api
  module V1
    class AccumulatorsReportController < ApplicationController

      def index
#        puts "estoy en el controller.................."
#        puts request.headers["CONTENT_TYPE"].inspect
#        puts request.format.inspect
#        puts "estoy en el controller.................."
        content_type = request.headers["CONTENT_TYPE"]
        index_handler({ params: params, model: :accumulator, thing: Thing }, content_type)
      end

      def show
        show_handler({ params: params, model: :accumulator })
      end
    end
  end
end
