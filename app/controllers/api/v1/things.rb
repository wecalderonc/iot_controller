module API
  module V1
    class Things < Grape::API
      include API::V1::Defaults

      resource :things do
        desc "Return list of things"
        get do
          Thing.all
        end
      end
    end
  end
end
