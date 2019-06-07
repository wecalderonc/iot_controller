module API
  module V2
    class Uplinks < Grape::API
      include API::V2::Defaults

      resource :uplinks do
        desc "Return list of uplinks"
        get do
          Uplink.all
        end
      end
    end
  end
end
