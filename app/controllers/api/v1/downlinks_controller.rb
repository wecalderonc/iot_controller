module Api
  module V1
    class DownlinksController < ApplicationController

      def create
        downlink = Shadows::Update::Execute.(create_params)

        if downlink.success?
          json_response(downlink.success)
        else
          json_response({ errors: downlink.failure[:message] })
        end
      end

      private

      def create_params
        _params = params.permit(:action_type, :input_method, :value, :thing_name).to_h.symbolize_keys
        Utils.symbolize_values(_params, [:action_type, :input_method])
      end
    end
  end
end
