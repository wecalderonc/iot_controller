module API
  module V1
    class Uplinks < Grape::API
      include API::V1::Defaults

      resource :uplinks do
        desc "Return list of uplinks"
        get do
          Uplink.all
        end
      end
    end
  end
end
