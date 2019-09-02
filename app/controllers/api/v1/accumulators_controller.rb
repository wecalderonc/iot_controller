module Api
  module V1
    class AccumulatorsController < ApplicationController
    include ActionController::MimeResponds
      load_and_authorize_resource

      def index
        thing_accumulators = Things::Accumulators::Index::Execute.new.(index_params)

        if thing_accumulators.success?
          authorized_accumulators = authorize(thing_accumulators)
          render json: authorized_accumulators, status: :ok, each_serializer: AccumulatorSerializer
        else
          json_response(thing_accumulators.failure, :not_found)
        end
      end

      private

      def index_params
        #TODO: Change this when thing_name -> aws_id·
        aws_id = params.permit(:thing_thing_name).to_h.symbolize_keys
        { thing_name: aws_id[:thing_thing_name] }
      end
    end
  end
end
