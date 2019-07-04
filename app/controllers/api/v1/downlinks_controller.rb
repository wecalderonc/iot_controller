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
        _params = params.permit(:action_type, :input_method, :value, :thing_name, :type).to_h.symbolize_keys
        _params.tap do |param|
          param[:action] = _params[:action_type].to_sym
          param[:type] = _params[:type].to_sym
        end
      end
    end
  end
end
