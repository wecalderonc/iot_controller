module API
  module V2
    class Things < Grape::API
      include API::V2::Defaults

      resource :things do
        desc "Return list of things"
        get do
          {version2: "que estás buscando aquí, todavía no hay nada"}
        end
      end
    end
  end
end
