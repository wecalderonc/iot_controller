module API
  module V2
    class Base < Grape::API
      mount API::V2::Uplinks
      mount API::V2::Things
    end
  end
end
