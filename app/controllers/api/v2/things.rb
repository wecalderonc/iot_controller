module API
  module V2
    class Things < Grape::API
      include API::V2::Defaults

      resource :things do
        desc "Return list of things"
        get do
          {version2: "ヽ(ಠ_ಠ)ノ(ಠ¿ಠ)",
           wtf: "what are you looking for?"
          }
        end
      end
    end
  end
end
